# Ubuntu 服务器部署指南

本文档专门针对 Ubuntu 20.04/22.04/24.04 LTS 系统编写，提供完整的后端部署流程。

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
# 更新软件包列表
sudo apt update

# 升级已安装的软件包
sudo apt upgrade -y

# 安装必要工具
sudo apt install -y wget curl git vim unzip software-properties-common
```

### 1.2 设置时区

```bash
# 设置为中国时区
sudo timedatectl set-timezone Asia/Shanghai

# 验证
date
```

### 1.3 配置主机名（可选）

```bash
# 设置主机名
sudo hostnamectl set-hostname anime-server

# 编辑hosts文件
sudo vim /etc/hosts
# 添加: 127.0.0.1 anime-server
```

---

## 2. 安装JDK 17

### 2.1 方式一：使用APT安装（推荐）

```bash
# 安装OpenJDK 17
sudo apt install -y openjdk-17-jdk

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
# 输出类似: /usr/lib/jvm/java-17-openjdk-amd64/bin/java

# 设置JAVA_HOME（如果未自动设置）
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' | sudo tee -a /etc/profile
source /etc/profile
```

---

## 3. 安装MySQL 8.0

### 3.1 安装MySQL

```bash
# 安装MySQL Server
sudo apt install -y mysql-server

# 启动MySQL服务
sudo systemctl start mysql
sudo systemctl enable mysql

# 检查服务状态
sudo systemctl status mysql
```

### 3.2 安全配置

```bash
# 运行安全配置脚本
sudo mysql_secure_installation
```

按照提示操作：
1. 设置root密码（建议设置强密码）
2. 移除匿名用户：Y
3. 禁止root远程登录：Y
4. 移除测试数据库：Y
5. 重新加载权限表：Y

### 3.3 创建数据库和用户

```bash
# 登录MySQL
sudo mysql -u root -p

# 执行以下SQL命令
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

### 3.4 配置MySQL（优化）

```bash
# 编辑MySQL配置文件
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
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
```

```bash
# 重启MySQL使配置生效
sudo systemctl restart mysql
```

### 3.5 导入初始数据

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
# 安装Redis
sudo apt install -y redis-server

# 启动服务
sudo systemctl start redis-server
sudo systemctl enable redis-server

# 验证
redis-cli ping
# 输出: PONG
```

### 4.2 配置Redis

```bash
# 编辑配置文件
sudo vim /etc/redis/redis.conf
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
```

```bash
# 重启Redis
sudo systemctl restart redis-server

# 测试连接（如果设置了密码）
redis-cli -a YourRedisPassword123! ping
```

---

## 5. 安装Nginx

### 5.1 安装Nginx

```bash
# 安装Nginx
sudo apt install -y nginx

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
sudo vim /etc/nginx/sites-available/anime-backend
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
# 启用配置
sudo ln -s /etc/nginx/sites-available/anime-backend /etc/nginx/sites-enabled/

# 删除默认配置（可选）
sudo rm /etc/nginx/sites-enabled/default

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
sudo chown -R www-data:www-data /var/www/anime_videos
sudo chmod -R 755 /var/www/anime_videos
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
sudo chown -R www-data:www-data /var/log/anime-backend
```

### 6.2 方式一：从源码构建

```bash
# 安装Maven
sudo apt install -y maven

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
After=network.target mysql.service redis-server.service
Wants=mysql.service redis-server.service

[Service]
Type=simple
User=www-data
Group=www-data
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

# 测试API
curl http://localhost:8080/api/videos

# 查看日志
tail -f /var/log/anime-backend/app.log
```

---

## 7. 配置域名和SSL

### 7.1 配置防火墙

```bash
# 查看防火墙状态
sudo ufw status

# 开放必要端口
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# 启用防火墙
sudo ufw enable

# 查看状态
sudo ufw status verbose
```

### 7.2 安装Certbot

```bash
# 安装Certbot
sudo apt install -y certbot python3-certbot-nginx

# 申请证书（需要域名已解析到服务器）
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# 按照提示输入邮箱，同意条款
```

### 7.3 自动续期

```bash
# 测试续期
sudo certbot renew --dry-run

# Certbot会自动添加续期定时任务
# 查看定时任务
sudo systemctl list-timers | grep certbot
```

### 7.4 配置HTTPS自动跳转

Certbot会自动修改Nginx配置，也可以手动修改：

```bash
sudo vim /etc/nginx/sites-available/anime-backend
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
sudo systemctl status mysql

# 测试连接
mysql -u anime_user -p -h localhost anime_website

# 检查MySQL日志
sudo tail -f /var/log/mysql/error.log
```

### 9.3 Redis连接失败

```bash
# 检查Redis状态
sudo systemctl status redis-server

# 测试连接
redis-cli ping

# 检查Redis日志
sudo tail -f /var/log/redis/redis-server.log
```

### 9.4 Nginx 502错误

```bash
# 检查后端服务
sudo systemctl status anime-backend

# 检查Nginx配置
sudo nginx -t

# 查看Nginx错误日志
sudo tail -f /var/log/nginx/error.log

# 检查SELinux（如果启用）
sudo setsebool -P httpd_can_network_connect 1
```

---

## 10. 一键部署脚本

创建一键部署脚本 `deploy.sh`：

```bash
#!/bin/bash

set -e

echo "==================================="
echo "Anime Website Backend 部署脚本"
echo "适用于 Ubuntu 20.04/22.04/24.04"
echo "==================================="

# 更新系统
echo "[1/8] 更新系统..."
sudo apt update && sudo apt upgrade -y

# 安装JDK
echo "[2/8] 安装 JDK 17..."
sudo apt install -y openjdk-17-jdk

# 安装MySQL
echo "[3/8] 安装 MySQL 8.0..."
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# 安装Redis
echo "[4/8] 安装 Redis..."
sudo apt install -y redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server

# 安装Nginx
echo "[5/8] 安装 Nginx..."
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 安装Maven
echo "[6/8] 安装 Maven..."
sudo apt install -y maven

# 创建目录
echo "[7/8] 创建应用目录..."
sudo mkdir -p /opt/anime-backend
sudo mkdir -p /var/log/anime-backend
sudo mkdir -p /var/www/anime_videos/{videos,covers,avatars}
sudo chown -R www-data:www-data /var/log/anime-backend
sudo chown -R www-data:www-data /var/www/anime_videos

# 配置防火墙
echo "[8/8] 配置防火墙..."
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

echo "==================================="
echo "基础环境安装完成！"
echo ""
echo "接下来请执行："
echo "1. 配置MySQL: sudo mysql_secure_installation"
echo "2. 创建数据库: mysql -u root -p < init_data.sql"
echo "3. 上传项目: scp target/*.jar user@server:/opt/anime-backend/"
echo "4. 创建服务: sudo vim /etc/systemd/system/anime-backend.service"
echo "5. 启动服务: sudo systemctl start anime-backend"
echo "==================================="
```

使用方法：

```bash
# 下载脚本
wget https://raw.githubusercontent.com/MCG2053/AI-Anime-website-backend/main/docs/deploy-ubuntu.sh

# 添加执行权限
chmod +x deploy-ubuntu.sh

# 执行
./deploy-ubuntu.sh
```

---

## 11. 参考链接

- 项目地址：https://github.com/MCG2053/AI-Anime-website-backend
- 前端项目：https://github.com/MCG2053/Anime_Website
- 问题反馈：GitHub Issues
