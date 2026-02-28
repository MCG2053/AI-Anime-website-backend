# 动漫网站后端操作手册

## 目录
1. [环境准备](#1-环境准备)
2. [数据库配置](#2-数据库配置)
3. [项目启动](#3-项目启动)
4. [数据管理](#4-数据管理)
5. [API测试](#5-api测试)
6. [前端对接](#6-前端对接)
7. [常见问题](#7-常见问题)
8. [Linux服务器部署](#8-linux服务器部署)
9. [Docker部署](#9-docker部署)

> 📖 **详细的API测试用例和示例请查看 [API_TEST.md](API_TEST.md)**

---

## 1. 环境准备

### 1.1 必需软件

| 软件 | 版本要求 | 下载地址 | 用途 |
|------|----------|----------|------|
| JDK | 17+ | https://adoptium.net/ | Java运行环境 |
| MySQL | 8.0+ | https://dev.mysql.com/downloads/ | 数据库 |
| Redis | 6.0+ | https://redis.io/download | 缓存服务 |
| Maven | 3.6+ | https://maven.apache.org/download.cgi | 项目构建 |

### 1.2 Windows环境安装

#### 1.2.1 安装JDK 17

1. 下载：https://adoptium.net/temurin/releases/?version=17
2. 选择 Windows x64 版本，下载 .msi 安装包
3. 双击安装，一路下一步
4. 验证安装：
```powershell
java -version
# 输出: openjdk version "17.x.x"
```

5. 配置环境变量（如果未自动配置）：
   - 右键"此电脑" → 属性 → 高级系统设置 → 环境变量
   - 新建系统变量 `JAVA_HOME`，值为 JDK 安装路径
   - 编辑 `Path`，添加 `%JAVA_HOME%\bin`

#### 1.2.2 安装MySQL 8.0

1. 下载：https://dev.mysql.com/downloads/installer/
2. 选择 "MySQL Installer for Windows"
3. 安装类型选择 "Developer Default"
4. 设置root密码（记住这个密码！）
5. 验证安装：
```powershell
mysql --version
# 输出: mysql  Ver 8.0.xx
```

#### 1.2.3 安装Redis（Windows）

Windows版Redis下载：https://github.com/tporadowski/redis/releases

1. 下载 Redis-x64-xxx.zip
2. 解压到 `C:\Redis`
3. 启动Redis：
```powershell
cd C:\Redis
.\redis-server.exe
```

4. 验证：
```powershell
.\redis-cli.exe ping
# 输出: PONG
```

#### 1.2.4 安装Maven

1. 下载：https://maven.apache.org/download.cgi
2. 下载 Binary zip archive
3. 解压到 `C:\Program Files\Apache\maven`
4. 配置环境变量：
   - 新建 `MAVEN_HOME`，值为 Maven 路径
   - 编辑 `Path`，添加 `%MAVEN_HOME%\bin`
5. 验证：
```powershell
mvn -version
# 输出: Apache Maven 3.x.x
```

### 1.3 Linux环境安装（CentOS/RHEL）

#### 1.3.1 安装JDK 17

```bash
# 方式一：使用yum安装
sudo yum install -y java-17-openjdk java-17-openjdk-devel

# 方式二：手动安装
# 下载JDK
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz

# 解压
sudo tar -xzf jdk-17_linux-x64_bin.tar.gz -C /usr/local/

# 配置环境变量
sudo tee /etc/profile.d/java.sh << 'EOF'
export JAVA_HOME=/usr/local/jdk-17
export PATH=$JAVA_HOME/bin:$PATH
EOF

# 使配置生效
source /etc/profile.d/java.sh

# 验证
java -version
```

#### 1.3.2 安装MySQL 8.0

```bash
# 添加MySQL官方仓库
sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

# 安装MySQL
sudo yum install -y mysql-community-server

# 启动MySQL
sudo systemctl start mysqld
sudo systemctl enable mysqld

# 获取临时密码
sudo grep 'temporary password' /var/log/mysqld.log

# 安全配置
sudo mysql_secure_installation

# 登录测试
mysql -u root -p
```

#### 1.3.3 安装Redis

```bash
# 安装EPEL源
sudo yum install -y epel-release

# 安装Redis
sudo yum install -y redis

# 启动Redis
sudo systemctl start redis
sudo systemctl enable redis

# 验证
redis-cli ping
# 输出: PONG
```

#### 1.3.4 安装Maven

```bash
# 下载Maven
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz

# 解压
sudo tar -xzf apache-maven-3.9.6-bin.tar.gz
sudo ln -s /opt/apache-maven-3.9.6 /opt/maven

# 配置环境变量
sudo tee /etc/profile.d/maven.sh << 'EOF'
export MAVEN_HOME=/opt/maven
export PATH=$MAVEN_HOME/bin:$PATH
EOF

# 使配置生效
source /etc/profile.d/maven.sh

# 验证
mvn -version
```

### 1.4 Linux环境安装（Ubuntu/Debian）

#### 1.4.1 安装JDK 17

```bash
# 更新包列表
sudo apt update

# 安装JDK 17
sudo apt install -y openjdk-17-jdk

# 验证
java -version
```

#### 1.4.2 安装MySQL 8.0

```bash
# 安装MySQL
sudo apt install -y mysql-server

# 启动MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# 安全配置
sudo mysql_secure_installation

# 登录测试
sudo mysql -u root -p
```

#### 1.4.3 安装Redis

```bash
# 安装Redis
sudo apt install -y redis-server

# 启动Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server

# 验证
redis-cli ping
```

#### 1.4.4 安装Maven

```bash
# 安装Maven
sudo apt install -y maven

# 验证
mvn -version
```

### 1.5 安装验证

**Windows PowerShell：**
```powershell
java -version
mvn -version
mysql --version
redis-cli --version
```

**Linux：**
```bash
java -version
mvn -version
mysql --version
redis-cli --version
```

### 1.6 启动必要服务

**Windows系统：**
```powershell
# 启动MySQL（如果未设置为自动启动）
net start mysql

# 启动Redis
cd C:\Redis
.\redis-server.exe
```

**Linux系统：**
```bash
# 启动MySQL
sudo systemctl start mysqld    # CentOS/RHEL
sudo systemctl start mysql     # Ubuntu/Debian

# 启动Redis
sudo systemctl start redis     # CentOS/RHEL
sudo systemctl start redis-server  # Ubuntu/Debian

# 查看服务状态
sudo systemctl status mysqld
sudo systemctl status redis
```

---

## 2. 数据库配置

### 2.1 创建数据库

打开MySQL命令行或使用图形化工具（如Navicat、DBeaver），执行：

```sql
-- 创建数据库
CREATE DATABASE anime_website 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 创建用户（可选，也可以使用root）
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';
FLUSH PRIVILEGES;
```

### 2.2 修改配置文件

编辑 `src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/anime_website?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    username: root          # 改成你的MySQL用户名
    password: root          # 改成你的MySQL密码
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  data:
    redis:
      host: localhost       # Redis地址
      port: 6379            # Redis端口
      password:              # Redis密码（如果有）
      database: 0

server:
  port: 8080                # 后端服务端口

jwt:
  secret: animeWebsiteSecretKeyForJWT2024VeryLongSecretKeyForSecurity
  expiration: 86400000      # Token有效期（毫秒），默认24小时
```

---

## 3. 项目启动

### 3.1 方式一：命令行启动

**Windows：**
```powershell
# 进入项目目录
cd f:\Code_Project\Trae\Anime_website_backend

# 编译项目（首次运行或代码修改后）
mvn clean install -DskipTests

# 启动项目
mvn spring-boot:run
```

**Linux：**
```bash
# 进入项目目录
cd /opt/anime-website-backend

# 编译项目
mvn clean install -DskipTests

# 启动项目
mvn spring-boot:run
```

### 3.2 方式二：IDE启动

**IDEA：**
1. 打开项目
2. 找到 `AnimeWebsiteBackendApplication.java`
3. 右键 → Run 'AnimeWebsiteBackendApplication'

**VS Code：**
1. 安装 Extension Pack for Java
2. 打开项目
3. 点击侧边栏的 Run and Debug
4. 选择 Spring Boot 启动

### 3.3 启动成功标志

看到以下日志表示启动成功：

```
Started AnimeWebsiteBackendApplication in X.XXX seconds
```

访问 http://localhost:8080/swagger-ui.html 可以看到API文档页面。

---

## 4. 数据管理

### 4.1 数据库表结构

项目启动后会自动创建以下表（JPA自动建表）：

| 表名 | 说明 |
|------|------|
| users | 用户表 |
| videos | 视频表 |
| episodes | 视频集数表 |
| categories | 分类表 |
| tags | 标签表 |
| video_tags | 视频标签关联表 |
| comments | 评论表 |
| danmaku | 弹幕表 |
| user_anime | 用户追番表 |
| watch_history | 观看历史表 |
| video_likes | 视频点赞表 |
| video_collections | 视频收藏表 |
| comment_likes | 评论点赞表 |

### 4.2 添加初始数据

创建SQL文件 `init_data.sql`，内容如下：

```sql
-- 使用数据库
USE anime_website;

-- 清空现有数据（谨慎使用）
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE video_tags;
TRUNCATE TABLE video_collections;
TRUNCATE TABLE video_likes;
TRUNCATE TABLE comment_likes;
TRUNCATE TABLE danmaku;
TRUNCATE TABLE comments;
TRUNCATE TABLE watch_history;
TRUNCATE TABLE user_anime;
TRUNCATE TABLE episodes;
TRUNCATE TABLE videos;
TRUNCATE TABLE tags;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- 插入分类
INSERT INTO categories (name, slug, icon) VALUES
('番剧', 'bangumi', '📺'),
('国创', 'guochuang', '🎬'),
('电影', 'movie', '🎥'),
('欧美', 'western', '🌍');

-- 插入标签
INSERT INTO tags (name, type) VALUES
('热血', 'genre'),
('恋爱', 'genre'),
('校园', 'genre'),
('奇幻', 'genre'),
('搞笑', 'genre'),
('日本', 'country'),
('中国', 'country'),
('美国', 'country');

-- 插入视频数据
INSERT INTO videos (title, cover, description, play_count, like_count, collect_count, episode, category, country, year, video_url, created_at, updated_at) VALUES
('进击的巨人 最终季', 'https://picsum.photos/seed/anime1/300/400', '在墙壁之外，有着宽广的世界。艾伦·耶格尔为了自由，踏上了通往大海的旅程...', 1000000, 50000, 30000, '更新至第16集', '番剧', '日本', 2024, 'https://example.com/video1.mp4', NOW(), NOW()),
('鬼灭之刃 柱训练篇', 'https://picsum.photos/seed/anime2/300/400', '鬼杀队最强的剑士"柱"们。为了打倒鬼舞辻无惨，开始了特训...', 800000, 40000, 25000, '全8集', '番剧', '日本', 2024, 'https://example.com/video2.mp4', NOW(), NOW()),
('斗罗大陆 第二季', 'https://picsum.photos/seed/anime3/300/400', '唐三与史莱克七怪的冒险继续，在斗罗大陆上书写传奇...', 2000000, 80000, 50000, '更新至第200集', '国创', '中国', 2024, 'https://example.com/video3.mp4', NOW(), NOW()),
('完美世界', 'https://picsum.photos/seed/anime4/300/400', '一粒尘可填海，一根草斩日月。石昊从大荒中走出...', 1500000, 60000, 40000, '更新至第100集', '国创', '中国', 2024, 'https://example.com/video4.mp4', NOW(), NOW()),
('间谍过家家 第二季', 'https://picsum.photos/seed/anime5/300/400', '黄昏、约尔、阿尼亚，这个临时组成的家庭继续着他们的秘密生活...', 900000, 45000, 28000, '更新至第12集', '番剧', '日本', 2024, 'https://example.com/video5.mp4', NOW(), NOW()),
('葬送的芙莉莲', 'https://picsum.photos/seed/anime6/300/400', '勇者一行打倒魔王后，精灵魔法使芙莉莲开始了寻找魔法之旅...', 1200000, 55000, 35000, '更新至第28集', '番剧', '日本', 2023, 'https://example.com/video6.mp4', NOW(), NOW()),
('咒术回战 第二季', 'https://picsum.photos/seed/anime7/300/400', '怀玉篇与玉折篇。五条悟的过去，夏油杰的堕落...', 1100000, 52000, 32000, '全23集', '番剧', '日本', 2023, 'https://example.com/video7.mp4', NOW(), NOW()),
('凡人修仙传', 'https://picsum.photos/seed/anime8/300/400', '韩立，一个普通的山村穷小子，偶然之下跨入江湖小门派...', 1800000, 70000, 45000, '更新至第150集', '国创', '中国', 2024, 'https://example.com/video8.mp4', NOW(), NOW());

-- 插入视频标签关联
INSERT INTO video_tags (video_id, tag_id) VALUES
(1, 1), (1, 4), (1, 6),  -- 进击的巨人：热血、奇幻、日本
(2, 1), (2, 4), (2, 6),  -- 鬼灭之刃：热血、奇幻、日本
(3, 1), (3, 4), (3, 7),  -- 斗罗大陆：热血、奇幻、中国
(4, 1), (4, 4), (4, 7),  -- 完美世界：热血、奇幻、中国
(5, 5), (5, 3), (5, 6),  -- 间谍过家家：搞笑、校园、日本
(6, 4), (6, 2), (6, 6),  -- 葬送的芙莉莲：奇幻、恋爱、日本
(7, 1), (7, 4), (7, 6),  -- 咒术回战：热血、奇幻、日本
(8, 1), (8, 4), (8, 7);  -- 凡人修仙传：热血、奇幻、中国

-- 插入视频集数
INSERT INTO episodes (video_id, title, video_url, duration, episode_number, created_at) VALUES
-- 进击的巨人
(1, '第1集', 'https://example.com/video1-ep1.mp4', 1440, 1, NOW()),
(1, '第2集', 'https://example.com/video1-ep2.mp4', 1440, 2, NOW()),
(1, '第3集', 'https://example.com/video1-ep3.mp4', 1440, 3, NOW()),
-- 鬼灭之刃
(2, '第1集', 'https://example.com/video2-ep1.mp4', 1440, 1, NOW()),
(2, '第2集', 'https://example.com/video2-ep2.mp4', 1440, 2, NOW()),
-- 斗罗大陆
(3, '第1集', 'https://example.com/video3-ep1.mp4', 1440, 1, NOW()),
(3, '第2集', 'https://example.com/video3-ep2.mp4', 1440, 2, NOW()),
(3, '第3集', 'https://example.com/video3-ep3.mp4', 1440, 3, NOW());

-- 创建测试用户（密码是 123456 的BCrypt加密）
-- 注意：实际使用时需要通过注册接口创建用户
INSERT INTO users (username, email, password, avatar, bio, created_at, updated_at) VALUES
('admin', 'admin@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', '管理员', NOW(), NOW());
```

### 4.3 执行SQL脚本

**Windows：**
```powershell
mysql -u root -p anime_website < init_data.sql
```

**Linux：**
```bash
mysql -u root -p anime_website < init_data.sql
```

**图形化工具：**
打开 Navicat/DBeaver/MySQL Workbench，连接数据库后执行SQL。

### 4.4 视频文件存储方案

视频文件有三种存储方式：

#### 方案一：本地文件服务器（开发推荐）

**Windows：**
1. 创建视频存储目录：
```
F:\anime_videos\
├── videos\          # 视频文件
├── covers\          # 封面图片
└── avatars\         # 用户头像
```

**Linux：**
```bash
# 创建目录
sudo mkdir -p /var/www/anime_videos/{videos,covers,avatars}

# 设置权限
sudo chown -R www-data:www-data /var/www/anime_videos
sudo chmod -R 755 /var/www/anime_videos
```

配置静态资源映射（需要添加配置类）：

```java
// Windows版本
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/videos/**")
                .addResourceLocations("file:F:/anime_videos/videos/");
        registry.addResourceHandler("/covers/**")
                .addResourceLocations("file:F:/anime_videos/covers/");
    }
}

// Linux版本
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/videos/**")
                .addResourceLocations("file:/var/www/anime_videos/videos/");
        registry.addResourceHandler("/covers/**")
                .addResourceLocations("file:/var/www/anime_videos/covers/");
    }
}
```

数据库中存储相对路径：
```sql
UPDATE videos SET video_url = '/videos/anime1.mp4' WHERE id = 1;
UPDATE videos SET cover = '/covers/anime1.jpg' WHERE id = 1;
```

#### 方案二：对象存储（生产推荐）

使用阿里云OSS、腾讯云COS、七牛云等：

```sql
-- 视频URL
UPDATE videos SET video_url = 'https://your-bucket.oss-cn-hangzhou.aliyuncs.com/videos/anime1.mp4';

-- 封面URL
UPDATE videos SET cover = 'https://your-bucket.oss-cn-hangzhou.aliyuncs.com/covers/anime1.jpg';
```

#### 方案三：第三方视频平台

使用B站、腾讯视频等嵌入链接：

```sql
UPDATE videos SET video_url = 'https://player.bilibili.com/player.html?aid=xxx' WHERE id = 1;
```

---

## 5. API测试

### 5.1 Swagger UI 测试

启动项目后访问：http://localhost:8080/swagger-ui.html

**测试流程：**

1. **注册用户**
   - 找到 `POST /api/user/register`
   - 点击 "Try it out"
   - 输入JSON：
   ```json
   {
     "username": "testuser",
     "email": "test@example.com",
     "password": "123456"
   }
   ```
   - 点击 "Execute"
   - 复制返回的 `token`

2. **授权登录**
   - 点击页面右上角 "Authorize"
   - 输入：`Bearer <刚才复制的token>`
   - 点击 "Authorize"

3. **测试其他接口**
   - 现在可以测试需要登录的接口了

### 5.2 Postman 测试

#### 5.2.1 创建环境变量
```
baseUrl: http://localhost:8080/api
token: (登录后自动设置)
```

#### 5.2.2 测试请求示例

**注册：**
```
POST {{baseUrl}}/user/register
Content-Type: application/json

{
  "username": "testuser",
  "email": "test@example.com",
  "password": "123456"
}
```

**登录：**
```
POST {{baseUrl}}/user/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "123456"
}
```

**获取视频列表：**
```
GET {{baseUrl}}/videos?page=1&pageSize=10
```

**获取视频详情：**
```
GET {{baseUrl}}/videos/1
```

**点赞视频（需要登录）：**
```
POST {{baseUrl}}/videos/1/like
Authorization: Bearer <token>
```

**发表评论（需要登录）：**
```
POST {{baseUrl}}/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "videoId": 1,
  "content": "这部动漫太好看了！"
}
```

### 5.3 cURL 测试

```bash
# 注册
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"123456"}'

# 登录
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456"}'

# 获取视频列表
curl http://localhost:8080/api/videos

# 点赞视频（替换YOUR_TOKEN）
curl -X POST http://localhost:8080/api/videos/1/like \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 6. 前端对接

### 6.1 修改前端配置

编辑前端项目 `.env.development`：

```env
VITE_API_BASE_URL=http://localhost:8080/api
```

### 6.2 启动前端

```bash
# Windows
cd F:\Code_Project\Trae\Anime_Website
npm install
npm run dev

# Linux
cd /opt/Anime_Website
npm install
npm run dev
```

### 6.3 跨域配置

后端已配置CORS，允许所有来源访问。如需限制，修改 `SecurityConfig.java`：

```java
@Configuration
.setAllowedOrigins(List.of("http://localhost:5173", "http://localhost:3000"))
```

---

## 7. 常见问题

### Q1: 启动报错 "Communications link failure"
**原因：** MySQL未启动或连接配置错误
**解决：**
1. 确认MySQL服务已启动
2. 检查 `application.yml` 中的数据库配置
3. 确认数据库 `anime_website` 已创建

### Q2: 启动报错 "Unable to connect to Redis"
**原因：** Redis未启动
**解决：**
```bash
# Windows
redis-server

# Linux
sudo systemctl start redis

# 或暂时禁用Redis（修改application.yml）
spring:
  data:
    redis:
      host: localhost
```

### Q3: 登录返回401错误
**原因：** Token无效或过期
**解决：**
1. 重新登录获取新Token
2. 检查Token格式：`Bearer <token>`

### Q4: 视频无法播放
**原因：** 视频URL无效或跨域问题
**解决：**
1. 确认视频URL可访问
2. 配置视频服务器的CORS
3. 使用对象存储服务

### Q5: 如何修改JWT密钥
**解决：** 修改 `application.yml`：
```yaml
jwt:
  secret: 你的新密钥（至少32个字符）
  expiration: 86400000
```

### Q6: 如何添加管理员用户
**解决：**
```sql
-- 密码为 admin123 的BCrypt加密值
INSERT INTO users (username, email, password, avatar, bio, created_at, updated_at)
VALUES ('admin', 'admin@example.com', '$2a$10$EqKcp1WFKVQISheBxkVJceXI1MPqGkKnMU7zD9hPA0VpQqGkKnMU7', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', '管理员', NOW(), NOW());
```

---

## 8. Linux服务器部署

### 8.1 准备服务器

推荐配置：
- CPU: 2核+
- 内存: 4GB+
- 硬盘: 50GB+
- 系统: CentOS 7/8 或 Ubuntu 20.04/22.04

### 8.2 安装必要软件

**CentOS/RHEL：**
```bash
# 更新系统
sudo yum update -y

# 安装必要工具
sudo yum install -y wget curl git vim

# 安装JDK 17
sudo yum install -y java-17-openjdk java-17-openjdk-devel

# 安装MySQL 8.0
sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum install -y mysql-community-server

# 安装Redis
sudo yum install -y epel-release
sudo yum install -y redis

# 启动服务
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo systemctl start redis
sudo systemctl enable redis
```

**Ubuntu/Debian：**
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装必要工具
sudo apt install -y wget curl git vim

# 安装JDK 17
sudo apt install -y openjdk-17-jdk

# 安装MySQL 8.0
sudo apt install -y mysql-server

# 安装Redis
sudo apt install -y redis-server

# 启动服务
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

### 8.3 配置MySQL

```bash
# 登录MySQL
mysql -u root -p

# 执行以下SQL
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 导入初始数据
mysql -u anime_user -p anime_website < init_data.sql
```

### 8.4 上传项目

```bash
# 方式一：使用Git
cd /opt
git clone https://github.com/MCG2053/AI-Anime-website-backend.git
cd AI-Anime-website-backend

# 方式二：使用SCP上传（在本地执行）
scp -r target/anime-website-backend-1.0.0.jar user@server:/opt/anime/

# 方式三：使用FTP/SFTP工具上传（FileZilla等）
```

### 8.5 配置生产环境配置文件

创建 `application-prod.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/anime_website?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    username: anime_user
    password: StrongPassword123!
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
  
  data:
    redis:
      host: localhost
      port: 6379
      password: 
      database: 0

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
```

### 8.6 打包项目

```bash
# 在项目目录执行
mvn clean package -DskipTests

# 生成的jar包位置
ls -la target/anime-website-backend-1.0.0.jar
```

### 8.7 创建系统服务

创建 systemd 服务文件：

```bash
sudo vim /etc/systemd/system/anime-backend.service
```

内容如下：

```ini
[Unit]
Description=Anime Website Backend Service
After=network.target mysql.service redis.service

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/anime-backend
ExecStart=/usr/bin/java -Xms512m -Xmx1024m -jar /opt/anime-backend/anime-website-backend-1.0.0.jar --spring.profiles.active=prod
ExecStop=/bin/kill -15 $MAINPID
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

启动服务：

```bash
# 重载systemd配置
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

### 8.8 配置Nginx反向代理

```bash
# 安装Nginx
sudo yum install -y nginx    # CentOS
sudo apt install -y nginx    # Ubuntu

# 创建配置文件
sudo vim /etc/nginx/conf.d/anime-backend.conf
```

Nginx配置内容：

```nginx
upstream anime_backend {
    server 127.0.0.1:8080;
    keepalive 32;
}

server {
    listen 80;
    server_name your-domain.com;  # 改成你的域名

    # 请求体大小限制（用于视频上传）
    client_max_body_size 100M;

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
    }

    location /covers/ {
        alias /var/www/anime_videos/covers/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

启动Nginx：

```bash
# 测试配置
sudo nginx -t

# 启动Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 重载配置
sudo nginx -s reload
```

### 8.9 配置防火墙

**CentOS/RHEL (firewalld)：**
```bash
# 开放端口
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp

# 重载防火墙
sudo firewall-cmd --reload

# 查看开放的端口
sudo firewall-cmd --list-ports
```

**Ubuntu (ufw)：**
```bash
# 开放端口
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp

# 启用防火墙
sudo ufw enable

# 查看状态
sudo ufw status
```

### 8.10 配置SSL证书（HTTPS）

使用 Let's Encrypt 免费证书：

```bash
# 安装Certbot
sudo yum install -y certbot python3-certbot-nginx    # CentOS
sudo apt install -y certbot python3-certbot-nginx    # Ubuntu

# 申请证书
sudo certbot --nginx -d your-domain.com

# 自动续期测试
sudo certbot renew --dry-run

# 证书自动续期已配置在systemd timer中
```

### 8.11 日志管理

```bash
# 创建日志目录
sudo mkdir -p /var/log/anime-backend
sudo chown www-data:www-data /var/log/anime-backend

# 配置日志轮转
sudo vim /etc/logrotate.d/anime-backend
```

内容：

```
/var/log/anime-backend/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0644 www-data www-data
    postrotate
        systemctl reload anime-backend > /dev/null 2>&1 || true
    endscript
}
```

### 8.12 监控与维护

```bash
# 查看服务状态
sudo systemctl status anime-backend

# 查看实时日志
sudo journalctl -u anime-backend -f

# 查看应用日志
tail -f /var/log/anime-backend/app.log

# 重启服务
sudo systemctl restart anime-backend

# 查看内存使用
free -h

# 查看CPU使用
top -p $(pgrep -f anime-website-backend)

# 查看端口占用
netstat -tlnp | grep 8080
```

---

## 9. Docker部署

### 9.1 安装Docker

**CentOS/RHEL：**
```bash
# 安装必要工具
sudo yum install -y yum-utils

# 添加Docker仓库
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 安装Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证
docker --version
```

**Ubuntu/Debian：**
```bash
# 安装必要工具
sudo apt install -y ca-certificates curl gnupg

# 添加Docker GPG密钥
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 添加Docker仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证
docker --version
```

### 9.2 创建Dockerfile

在项目根目录创建 `Dockerfile`：

```dockerfile
# 构建阶段
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 运行阶段
FROM eclipse-temurin:17-jre
WORKDIR /app

# 创建非root用户
RUN groupadd -r anime && useradd -r -g anime anime

# 复制jar包
COPY --from=builder /app/target/anime-website-backend-1.0.0.jar app.jar

# 创建日志目录
RUN mkdir -p /var/log/anime-backend && chown -R anime:anime /var/log/anime-backend

# 切换用户
USER anime

# 暴露端口
EXPOSE 8080

# JVM参数
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

### 9.3 创建docker-compose.yml

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: anime-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: anime_website
      MYSQL_USER: anime_user
      MYSQL_PASSWORD: animepassword
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./docs/init_data.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - anime-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: anime-redis
    restart: always
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - anime-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build: .
    container_name: anime-backend
    restart: always
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/anime_website?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
      SPRING_DATASOURCE_USERNAME: anime_user
      SPRING_DATASOURCE_PASSWORD: animepassword
      SPRING_DATA_REDIS_HOST: redis
      SPRING_DATA_REDIS_PORT: 6379
      JWT_SECRET: YourProductionSecretKeyMustBeVeryLongAndSecure2024!
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - ./logs:/var/log/anime-backend
      - ./videos:/var/www/anime_videos/videos
      - ./covers:/var/www/anime_videos/covers
    networks:
      - anime-network

  nginx:
    image: nginx:alpine
    container_name: anime-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./ssl:/etc/nginx/ssl
      - ./videos:/var/www/anime_videos/videos:ro
      - ./covers:/var/www/anime_videos/covers:ro
    depends_on:
      - backend
    networks:
      - anime-network

volumes:
  mysql_data:
  redis_data:

networks:
  anime-network:
    driver: bridge
```

### 9.4 构建并运行

```bash
# 构建镜像
docker build -t anime-backend:latest .

# 使用docker-compose启动所有服务
docker compose up -d

# 查看运行状态
docker compose ps

# 查看日志
docker compose logs -f backend

# 停止所有服务
docker compose down

# 停止并删除数据卷
docker compose down -v
```

### 9.5 Docker常用命令

```bash
# 查看所有容器
docker ps -a

# 查看镜像
docker images

# 进入容器
docker exec -it anime-backend /bin/bash

# 查看容器日志
docker logs -f anime-backend

# 重启容器
docker restart anime-backend

# 停止容器
docker stop anime-backend

# 删除容器
docker rm anime-backend

# 删除镜像
docker rmi anime-backend:latest

# 查看容器资源使用
docker stats anime-backend

# 导出镜像
docker save anime-backend:latest | gzip > anime-backend.tar.gz

# 导入镜像
docker load < anime-backend.tar.gz
```

### 9.6 Docker镜像推送（可选）

```bash
# 登录Docker Hub
docker login

# 标记镜像
docker tag anime-backend:latest your-username/anime-backend:latest

# 推送镜像
docker push your-username/anime-backend:latest
```

---

## 10. 技术支持

- 项目地址：https://github.com/MCG2053/AI-Anime-website-backend
- 前端项目：https://github.com/MCG2053/AI-Anime-website
- 问题反馈：GitHub Issues
