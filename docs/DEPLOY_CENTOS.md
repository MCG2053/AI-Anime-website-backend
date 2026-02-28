# CentOS 服务器部署指南

本文档专门针对 CentOS 7/8/9 / RHEL / Rocky Linux / AlmaLinux 系统编写，提供完整的后端部署流程。

---

## 目录

1. [系统准备](#1-系统准备)
2. [安装JDK 17](#2-安装jdk-17)
3. [安装MySQL 8.0](#3-安装mysql-80)
4. [安装Redis](#4-安装redis)
5. [安装Nginx](#5-安装nginx)
6. [部署后端项目](#6-部署后端项目)
7. [配置域名和SSL](#7-配置域名和ssl)
8. [常用维护命令](#8-常用维护命令)

---

## 1. 系统准备

### 1.1 更新系统

```bash
# CentOS 7
sudo yum update -y

# CentOS 8/9 / Rocky / AlmaLinux
sudo dnf update -y

# 安装必要工具
sudo yum install -y wget curl git vim unzip
```

### 1.2 设置时区

```bash
# 设置为中国时区
sudo timedatectl set-timezone Asia/Shanghai

# 验证
date
```

### 1.3 关闭SELinux（可选，简化配置）

```bash
# 临时关闭
sudo setenforce 0

# 永久关闭
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 查看状态
sestatus
```

### 1.4 配置主机名（可选）

```bash
# 设置主机名
sudo hostnamectl set-hostname anime-server

# 编辑hosts文件
sudo vim /etc/hosts
# 添加: 127.0.0.1 anime-server
```

---

## 2. 安装JDK 17

### 2.1 方式一：使用YUM安装（推荐）

```bash
# CentOS 7 (需要先安装EPEL)
sudo yum install -y epel-release
sudo yum install -y java-17-openjdk java-17-openjdk-devel

# CentOS 8/9 / Rocky / AlmaLinux
sudo dnf install -y java-17-openjdk java-17-openjdk-devel

# 验证安装
java -version
# 输出: openjdk version "17.0.x"
```

### 2.2 方式二：手动安装

```bash
# 下载JDK 17
cd /tmp
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz

# 解压到/usr/local
sudo tar -xzf jdk-17_linux-x64_bin.tar.gz -C /usr/local/

# 创建软链接
sudo ln -sf /usr/local/jdk-17* /usr/local/java

# 配置环境变量
sudo tee /etc/profile.d/java.sh << 'EOF'
export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$PATH
EOF

# 使配置生效
source /etc/profile.d/java.sh

# 验证
java -version
```

### 2.3 配置JAVA_HOME

```bash
# 查看Java安装路径
readlink -f $(which java)
# 输出类似: /usr/lib/jvm/java-17-openjdk-17.x.x.x/bin/java

# 设置JAVA_HOME（如果未自动设置）
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' | sudo tee -a /etc/profile
source /etc/profile
```

---

## 3. 安装MySQL 8.0

### 3.1 添加MySQL仓库

```bash
# CentOS 7
sudo yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm

# CentOS 8 / Rocky 8
sudo dnf localinstall -y https://dev.mysql.com/get/mysql80-community-release-el8-7.noarch.rpm

# CentOS 9 / Rocky 9
sudo dnf localinstall -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
```

### 3.2 安装MySQL

```bash
# CentOS 7
sudo yum install -y mysql-community-server

# CentOS 8/9 / Rocky / AlmaLinux
sudo dnf install -y mysql-community-server

# 启动MySQL服务
sudo systemctl start mysqld
sudo systemctl enable mysqld

# 检查服务状态
sudo systemctl status mysqld
```

### 3.3 获取临时密码并修改

```bash
# 获取临时密码
sudo grep 'temporary password' /var/log/mysqld.log

# 使用临时密码登录
mysql -u root -p

# 修改root密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewStrongPassword123!';

# 退出
EXIT;
```

### 3.4 安全配置

```bash
# 运行安全配置脚本
sudo mysql_secure_installation
```

按照提示操作：
1. 输入root密码
2. 设置密码强度验证：根据需求选择
3. 移除匿名用户：Y
4. 禁止root远程登录：Y
5. 移除测试数据库：Y
6. 重新加载权限表：Y

### 3.5 创建数据库和用户

```bash
# 登录MySQL
mysql -u root -p
```

```sql
-- 创建数据库
CREATE DATABASE anime_website 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 创建专用用户
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'YourStrongPassword123!';

-- 授权
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 退出
EXIT;
```

### 3.6 配置MySQL（优化）

```bash
# 编辑MySQL配置文件
sudo vim /etc/my.cnf
```

添加/修改以下配置：

```ini
[mysqld]
# 字符集设置
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# 性能优化（根据服务器配置调整）
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
max_connections = 200

# 慢查询日志
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2

[client]
default-character-set = utf8mb4
```

```bash
# 创建日志目录
sudo mkdir -p /var/log/mysql
sudo chown mysql:mysql /var/log/mysql

# 重启MySQL使配置生效
sudo systemctl restart mysqld
```

### 3.7 导入初始数据

```bash
# 下载初始化SQL文件
wget https://raw.githubusercontent.com/MCG2053/AI-Anime-website-backend/main/docs/init_data.sql -O init_data.sql

# 导入数据
mysql -u anime_user -p anime_website < init_data.sql

# 验证数据
mysql -u anime_user -p anime_website -e "SHOW TABLES;"
```

---

## 4. 安装Redis

### 4.1 安装Redis

```bash
# CentOS 7
sudo yum install -y epel-release
sudo yum install -y redis

# CentOS 8/9 / Rocky / AlmaLinux
sudo dnf install -y redis

# 启动服务
sudo systemctl start redis
sudo systemctl enable redis

# 验证
redis-cli ping
# 输出: PONG
```

### 4.2 配置Redis

```bash
# 编辑配置文件
sudo vim /etc/redis.conf
```

修改以下配置：

```ini
# 绑定地址（生产环境建议只绑定本地）
bind 127.0.0.1

# 保护模式
protected-mode yes

# 端口
port 6379

# 密码（建议设置）
# requirepass YourRedisPassword123!

# 最大内存
maxmemory 256mb

# 内存策略
maxmemory-policy allkeys-lru

# 持久化
appendonly yes
appendfsync everysec

# 后台运行
daemonize no
```

```bash
# 重启Redis
sudo systemctl restart redis

# 测试连接（如果设置了密码）
redis-cli -a YourRedisPassword123! ping
```

---

## 5. 安装Nginx

### 5.1 安装Nginx

```bash
# CentOS 7
sudo yum install -y epel-release
sudo yum install -y nginx

# CentOS 8/9 / Rocky / AlmaLinux
sudo dnf install -y nginx

# 启动服务
sudo systemctl start nginx
sudo systemctl enable nginx

# 验证
nginx -v
# 访问 http://服务器IP 应该看到Nginx欢迎页
```

### 5.2 配置Nginx

```bash
# 创建后端配置文件
sudo vim /etc/nginx/conf.d/anime-backend.conf
```

配置内容：

```nginx
upstream anime_backend {
    server 127.0.0.1:8080;
    keepalive 32;
}

server {
    listen 80;
    server_name your-domain.com;  # 改成你的域名或服务器IP

    # 请求体大小限制
    client_max_body_size 100M;

    # Gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
    gzip_min_length 1024;

    # API请求
    location /api/ {
        proxy_pass http://anime_backend/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Swagger文档
    location /swagger-ui/ {
        proxy_pass http://anime_backend/swagger-ui/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /api-docs/ {
        proxy_pass http://anime_backend/api-docs/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # 静态资源（视频、封面等）
    location /videos/ {
        alias /var/www/anime_videos/videos/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin *;
    }

    location /covers/ {
        alias /var/www/anime_videos/covers/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin *;
    }

    # 健康检查
    location /health {
        access_log off;
        return 200 "OK";
        add_header Content-Type text/plain;
    }
}
```

```bash
# 备份并移除默认配置
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# 测试配置
sudo nginx -t

# 重载Nginx
sudo systemctl reload nginx
```

### 5.3 创建静态资源目录

```bash
# 创建目录
sudo mkdir -p /var/www/anime_videos/{videos,covers,avatars}

# 设置权限
sudo chown -R nginx:nginx /var/www/anime_videos
sudo chmod -R 755 /var/www/anime_videos
```

### 5.4 配置SELinux（如果启用）

```bash
# 允许Nginx网络连接
sudo setsebool -P httpd_can_network_connect 1

# 允许Nginx读取静态文件
sudo chcon -R -t httpd_sys_content_t /var/www/anime_videos/

# 允许Nginx写入日志
sudo chcon -R -t httpd_log_t /var/log/nginx/
```

---

## 6. 部署后端项目

### 6.1 创建应用目录

```bash
# 创建应用目录
sudo mkdir -p /opt/anime-backend
sudo mkdir -p /var/log/anime-backend

# 设置权限
sudo chown -R $USER:$USER /opt/anime-backend
sudo chown -R nginx:nginx /var/log/anime-backend
```

### 6.2 方式一：从源码构建

```bash
# 安装Maven
sudo yum install -y maven    # CentOS 7
sudo dnf install -y maven    # CentOS 8/9

# 克隆项目
cd /opt
git clone https://github.com/MCG2053/AI-Anime-website-backend.git anime-backend-src
cd anime-backend-src

# 构建项目
mvn clean package -DskipTests

# 复制jar包
cp target/anime-website-backend-1.0.0.jar /opt/anime-backend/
```

### 6.3 方式二：直接上传jar包

在本地Windows执行：

```powershell
# 使用SCP上传
scp target/anime-website-backend-1.0.0.jar user@your-server-ip:/opt/anime-backend/
```

或使用 FileZilla、WinSCP 等工具上传。

### 6.4 创建生产环境配置

```bash
# 创建配置文件
sudo vim /opt/anime-backend/application-prod.yml
```

内容：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/anime_website?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    username: anime_user
    password: YourStrongPassword123!
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      idle-timeout: 300000
      connection-timeout: 20000
  
  data:
    redis:
      host: localhost
      port: 6379
      password: 
      database: 0
      timeout: 10000ms

server:
  port: 8080

jwt:
  secret: YourProductionSecretKeyMustBeVeryLongAndSecure2024!
  expiration: 86400000

logging:
  level:
    root: INFO
    com.anime.website: DEBUG
  file:
    name: /var/log/anime-backend/app.log
  logback:
    rollingpolicy:
      max-file-size: 10MB
      max-history: 30
```

### 6.5 创建Systemd服务

```bash
# 创建服务文件
sudo vim /etc/systemd/system/anime-backend.service
```

内容：

```ini
[Unit]
Description=Anime Website Backend Service
Documentation=https://github.com/MCG2053/AI-Anime-website-backend
After=network.target mysqld.service redis.service
Wants=mysqld.service redis.service

[Service]
Type=simple
User=nginx
Group=nginx
WorkingDirectory=/opt/anime-backend
Environment="JAVA_OPTS=-Xms512m -Xmx1024m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
Environment="SPRING_PROFILES_ACTIVE=prod"
ExecStart=/usr/bin/java $JAVA_OPTS -jar /opt/anime-backend/anime-website-backend-1.0.0.jar
ExecStop=/bin/kill -15 $MAINPID
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
```

```bash
# 重载systemd
sudo systemctl daemon-reload

# 启动服务
sudo systemctl start anime-backend

# 设置开机自启
sudo systemctl enable anime-backend

# 查看状态
sudo systemctl status anime-backend

# 查看日志
sudo journalctl -u anime-backend -f
```

### 6.6 验证部署

```bash
# 检查端口
sudo netstat -tlnp | grep 8080

# 或使用 ss 命令
sudo ss -tlnp | grep 8080

# 测试API
curl http://localhost:8080/api/videos

# 查看日志
tail -f /var/log/anime-backend/app.log
```

---

## 7. 配置域名和SSL

### 7.1 配置防火墙（firewalld）

```bash
# 查看防火墙状态
sudo systemctl status firewalld

# 开放必要端口
sudo firewall-cmd --permanent --add-port=22/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp

# 重载防火墙
sudo firewall-cmd --reload

# 查看开放的端口
sudo firewall-cmd --list-ports
```

### 7.2 安装Certbot

```bash
# CentOS 7
sudo yum install -y epel-release
sudo yum install -y certbot python2-certbot-nginx

# CentOS 8/9 / Rocky / AlmaLinux
sudo dnf install -y certbot python3-certbot-nginx

# 申请证书（需要域名已解析到服务器）
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# 按照提示输入邮箱，同意条款
```

### 7.3 自动续期

```bash
# 测试续期
sudo certbot renew --dry-run

# 添加定时任务自动续期
sudo crontab -e
```

添加以下内容：

```
# 每天凌晨2点检查并续期证书
0 2 * * * /usr/bin/certbot renew --quiet --post-hook "systemctl reload nginx"
```

### 7.4 配置HTTPS自动跳转

Certbot会自动修改Nginx配置，也可以手动修改：

```bash
sudo vim /etc/nginx/conf.d/anime-backend.conf
```

确保包含：

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # SSL配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    
    # ... 其他配置同上
}
```

---

## 8. 常用维护命令

### 8.1 服务管理

```bash
# 启动服务
sudo systemctl start anime-backend

# 停止服务
sudo systemctl stop anime-backend

# 重启服务
sudo systemctl restart anime-backend

# 查看状态
sudo systemctl status anime-backend

# 查看日志
sudo journalctl -u anime-backend -f

# 查看最近100行日志
sudo journalctl -u anime-backend -n 100
```

### 8.2 日志查看

```bash
# 实时查看应用日志
tail -f /var/log/anime-backend/app.log

# 查看最近错误
grep -i error /var/log/anime-backend/app.log | tail -20

# 查看Nginx访问日志
tail -f /var/log/nginx/access.log

# 查看Nginx错误日志
tail -f /var/log/nginx/error.log
```

### 8.3 数据库维护

```bash
# 登录MySQL
mysql -u anime_user -p anime_website

# 备份数据库
mysqldump -u anime_user -p anime_website > backup_$(date +%Y%m%d).sql

# 恢复数据库
mysql -u anime_user -p anime_website < backup_20240101.sql

# 查看数据库大小
mysql -u anime_user -p -e "SELECT table_schema AS 'Database', 
ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' 
FROM information_schema.tables 
WHERE table_schema = 'anime_website' 
GROUP BY table_schema;"
```

### 8.4 系统监控

```bash
# 查看内存使用
free -h

# 查看磁盘使用
df -h

# 查看CPU使用
top -p $(pgrep -f anime-website-backend)

# 查看进程
ps aux | grep java

# 查看端口占用
sudo netstat -tlnp | grep -E '8080|3306|6379|80|443'

# 或使用 ss
sudo ss -tlnp | grep -E '8080|3306|6379|80|443'

# 查看系统负载
uptime
```

### 8.5 性能优化

```bash
# 查看JVM内存使用
jstat -gc $(pgrep -f anime-website-backend)

# 生成堆转储（用于分析内存问题）
jmap -dump:format=b,file=/tmp/heap.hprof $(pgrep -f anime-website-backend)

# 查看线程堆栈
jstack $(pgrep -f anime-website-backend) > /tmp/thread.txt
```

---

## 9. 故障排查

### 9.1 服务无法启动

```bash
# 查看详细错误
sudo journalctl -u anime-backend -n 50 --no-pager

# 检查配置文件
cat /opt/anime-backend/application-prod.yml

# 检查端口占用
sudo lsof -i :8080

# 手动启动测试
cd /opt/anime-backend
java -jar anime-website-backend-1.0.0.jar --spring.profiles.active=prod
```

### 9.2 数据库连接失败

```bash
# 检查MySQL状态
sudo systemctl status mysqld

# 测试连接
mysql -u anime_user -p -h localhost anime_website

# 检查MySQL日志
sudo tail -f /var/log/mysqld.log
```

### 9.3 Redis连接失败

```bash
# 检查Redis状态
sudo systemctl status redis

# 测试连接
redis-cli ping

# 检查Redis日志
sudo tail -f /var/log/redis/redis.log
```

### 9.4 Nginx 502错误

```bash
# 检查后端服务
sudo systemctl status anime-backend

# 检查Nginx配置
sudo nginx -t

# 查看Nginx错误日志
sudo tail -f /var/log/nginx/error.log

# 检查SELinux
sudo setsebool -P httpd_can_network_connect 1
```

### 9.5 SELinux问题

```bash
# 查看SELinux状态
sestatus

# 查看SELinux日志
sudo ausearch -m avc -ts recent

# 生成策略（如果有拒绝）
sudo ausearch -c 'java' --raw | audit2allow -M my-java
sudo semodule -i my-java.pp
```

---

## 10. 一键部署脚本

创建一键部署脚本 `deploy-centos.sh`：

```bash
#!/bin/bash

set -e

echo "==================================="
echo "Anime Website Backend 部署脚本"
echo "适用于 CentOS 7/8/9 / Rocky / AlmaLinux"
echo "==================================="

# 检测系统版本
if [ -f /etc/centos-release ]; then
    OS="centos"
elif [ -f /etc/rocky-release ]; then
    OS="rocky"
elif [ -f /etc/almalinux-release ]; then
    OS="alma"
else
    echo "未检测到支持的系统"
    exit 1
fi

# 包管理器选择
if command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
else
    PKG_MANAGER="yum"
fi

echo "检测到系统: $OS"
echo "使用包管理器: $PKG_MANAGER"

# 更新系统
echo "[1/8] 更新系统..."
sudo $PKG_MANAGER update -y

# 安装EPEL（CentOS 7需要）
if [ "$OS" = "centos" ] && [ "$PKG_MANAGER" = "yum" ]; then
    echo "[2/8] 安装 EPEL..."
    sudo $PKG_MANAGER install -y epel-release
fi

# 安装JDK
echo "[3/8] 安装 JDK 17..."
sudo $PKG_MANAGER install -y java-17-openjdk java-17-openjdk-devel

# 安装MySQL
echo "[4/8] 安装 MySQL 8.0..."
if [ "$PKG_MANAGER" = "yum" ]; then
    sudo $PKG_MANAGER localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm
else
    sudo $PKG_MANAGER localinstall -y https://dev.mysql.com/get/mysql80-community-release-el8-7.noarch.rpm
fi
sudo $PKG_MANAGER install -y mysql-community-server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# 安装Redis
echo "[5/8] 安装 Redis..."
sudo $PKG_MANAGER install -y redis
sudo systemctl start redis
sudo systemctl enable redis

# 安装Nginx
echo "[6/8] 安装 Nginx..."
sudo $PKG_MANAGER install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 安装Maven
echo "[7/8] 安装 Maven..."
sudo $PKG_MANAGER install -y maven

# 创建目录
echo "[8/8] 创建应用目录..."
sudo mkdir -p /opt/anime-backend
sudo mkdir -p /var/log/anime-backend
sudo mkdir -p /var/www/anime_videos/{videos,covers,avatars}
sudo chown -R nginx:nginx /var/log/anime-backend
sudo chown -R nginx:nginx /var/www/anime_videos

# 配置防火墙
echo "[额外] 配置防火墙..."
if command -v firewall-cmd &> /dev/null; then
    sudo firewall-cmd --permanent --add-port=22/tcp
    sudo firewall-cmd --permanent --add-port=80/tcp
    sudo firewall-cmd --permanent --add-port=443/tcp
    sudo firewall-cmd --reload
fi

echo "==================================="
echo "基础环境安装完成！"
echo ""
echo "接下来请执行："
echo "1. 获取MySQL临时密码: sudo grep 'temporary password' /var/log/mysqld.log"
echo "2. 登录并修改密码: mysql -u root -p"
echo "3. 创建数据库和用户"
echo "4. 上传项目: scp target/*.jar user@server:/opt/anime-backend/"
echo "5. 创建服务: sudo vim /etc/systemd/system/anime-backend.service"
echo "6. 启动服务: sudo systemctl start anime-backend"
echo "==================================="
```

使用方法：

```bash
# 下载脚本
wget https://raw.githubusercontent.com/MCG2053/AI-Anime-website-backend/main/docs/deploy-centos.sh

# 添加执行权限
chmod +x deploy-centos.sh

# 执行
./deploy-centos.sh
```

---

## 11. 参考链接

- 项目地址：https://github.com/MCG2053/AI-Anime-website-backend
- 前端项目：https://github.com/MCG2053/Anime_Website
- 问题反馈：GitHub Issues
