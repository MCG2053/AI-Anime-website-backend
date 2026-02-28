# 快速入门指南

## 🚀 5分钟快速启动

---

### Windows 环境

#### 第一步：准备环境

确保已安装以下软件：
- ✅ JDK 17+
- ✅ MySQL 8.0+
- ✅ Maven 3.6+

#### 第二步：创建数据库

打开MySQL命令行或图形工具，执行：

```sql
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 第三步：修改配置

编辑 `src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    username: root     # 改成你的用户名
    password: root     # 改成你的密码
```

#### 第四步：启动项目

```powershell
# 进入项目目录
cd f:\Code_Project\Trae\Anime_website_backend

# 启动
mvn spring-boot:run
```

看到 `Started AnimeWebsiteBackendApplication` 表示启动成功！

#### 第五步：导入测试数据

```powershell
mysql -u root -p anime_website < docs/init_data.sql
```

#### 第六步：测试API

访问：http://localhost:8080/swagger-ui.html

---

### Linux (Ubuntu) 环境

#### 第一步：安装环境

```bash
# 更新系统
sudo apt update

# 安装JDK、MySQL、Redis
sudo apt install -y openjdk-17-jdk mysql-server redis-server maven

# 启动服务
sudo systemctl start mysql redis-server
sudo systemctl enable mysql redis-server
```

#### 第二步：创建数据库

```bash
# 登录MySQL
sudo mysql

# 执行SQL
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'YourPassword123!';
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 第三步：克隆并启动项目

```bash
# 克隆项目
git clone https://github.com/MCG2053/AI-Anime-website-backend.git
cd AI-Anime-website-backend

# 修改配置
vim src/main/resources/application.yml
# 修改数据库用户名密码

# 启动
mvn spring-boot:run
```

#### 第四步：导入测试数据

```bash
mysql -u anime_user -p anime_website < docs/init_data.sql
```

#### 第五步：测试API

```bash
curl http://localhost:8080/api/videos
```

---

### Linux (CentOS) 环境

#### 第一步：安装环境

```bash
# 安装EPEL
sudo yum install -y epel-release

# 安装JDK、MySQL、Redis
sudo yum install -y java-17-openjdk java-17-openjdk-devel
sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm
sudo yum install -y mysql-community-server redis maven

# 启动服务
sudo systemctl start mysqld redis
sudo systemctl enable mysqld redis
```

#### 第二步：配置MySQL

```bash
# 获取临时密码
sudo grep 'temporary password' /var/log/mysqld.log

# 登录并修改密码
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword123!';

# 创建数据库
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'YourPassword123!';
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 第三步：克隆并启动项目

```bash
# 克隆项目
git clone https://github.com/MCG2053/AI-Anime-website-backend.git
cd AI-Anime-website-backend

# 修改配置
vim src/main/resources/application.yml

# 启动
mvn spring-boot:run
```

---

## 📱 前端对接

修改前端项目 `.env.development`：

```env
VITE_API_BASE_URL=http://localhost:8080/api
```

启动前端：

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

---

## 🎬 添加自己的视频

### 方法一：直接修改数据库

```sql
-- 添加视频
INSERT INTO videos (title, cover, description, play_count, like_count, collect_count, episode, category, country, year, video_url, created_at, updated_at)
VALUES ('我的视频', '封面URL', '视频描述', 0, 0, 0, '全1集', '番剧', '日本', 2024, '视频URL', NOW(), NOW());

-- 添加集数
INSERT INTO episodes (video_id, title, video_url, duration, episode_number, created_at)
VALUES (LAST_INSERT_ID(), '第1集', '视频URL', 1440, 1, NOW());
```

### 方法二：使用API（需要先登录）

1. 注册用户：
```bash
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","email":"admin@test.com","password":"123456"}'
```

2. 登录获取Token

3. 使用Token调用其他API

---

## 📁 视频文件存放

### 本地存储（开发用）

**Windows：**
1. 创建目录：`F:\anime_videos\videos\`
2. 放入视频文件：`F:\anime_videos\videos\myvideo.mp4`
3. 数据库URL填：`/videos/myvideo.mp4`

**Linux：**
```bash
# 创建目录
sudo mkdir -p /var/www/anime_videos/videos

# 放入视频文件
sudo cp myvideo.mp4 /var/www/anime_videos/videos/

# 设置权限
sudo chown -R www-data:www-data /var/www/anime_videos  # Ubuntu
sudo chown -R nginx:nginx /var/www/anime_videos        # CentOS
```

### 云存储（生产用）

使用阿里云OSS、七牛云等，URL直接填完整地址。

---

## ❓ 常见问题

**Q: 启动报错连接数据库失败？**
A: 检查MySQL是否启动，用户名密码是否正确

**Q: 前端请求跨域？**
A: 后端已配置CORS，检查前端API地址是否正确

**Q: 视频播放不了？**
A: 检查视频URL是否可访问，建议使用云存储

**Q: Linux端口被占用？**
A: 使用 `sudo lsof -i :8080` 查看占用进程

---

## 📞 获取帮助

- 详细文档：[OPERATION_GUIDE.md](OPERATION_GUIDE.md)
- Ubuntu部署：[DEPLOY_UBUNTU.md](DEPLOY_UBUNTU.md)
- CentOS部署：[DEPLOY_CENTOS.md](DEPLOY_CENTOS.md)
- API文档：http://localhost:8080/swagger-ui.html
- GitHub：https://github.com/MCG2053/AI-Anime-website-backend
