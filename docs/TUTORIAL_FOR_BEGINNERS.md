# 🎓 动漫网站后端 - 超级详细新手教程

> 本教程适合完全没有后端开发经验的超级新手，每一步都有详细说明和截图指引。

---

## 📋 目录

- [第一部分：概念解释](#第一部分概念解释)
- [第二部分：Windows 环境搭建](#第二部分windows-环境搭建)
- [第三部分：Ubuntu 环境搭建](#第三部分ubuntu-环境搭建)
- [第四部分：CentOS 环境搭建](#第四部分centos-环境搭建)
- [第五部分：项目配置详解](#第五部分项目配置详解)
- [第六部分：启动项目](#第六部分启动项目)
- [第七部分：常见错误解决](#第七部分常见错误解决)
- [第八部分：测试验证](#第八部分测试验证)

---

## 第一部分：概念解释

### 1.1 这是什么项目？

这是一个**后端服务程序**，就像餐厅的**厨房**：
- **前端** = 餐厅大堂（用户看到的界面）
- **后端** = 餐厅厨房（处理数据、存储数据）
- **数据库** = 仓库（存储所有数据）

### 1.2 需要安装什么？

| 软件 | 是什么 | 为什么需要 |
|------|--------|------------|
| JDK 17 | Java运行环境 | 后端是用Java写的，需要Java才能运行 |
| MySQL | 数据库 | 存储用户、视频等所有数据 |
| Redis | 缓存 | 加速数据读取，提高性能 |
| Maven | 构建工具 | 帮助编译和运行Java项目 |

### 1.3 项目运行流程

```
用户访问网站 → 前端发送请求 → 后端处理 → 数据库存储/读取 → 返回结果
```

---

## 第二部分：Windows 环境搭建

### 2.1 安装 JDK 17

#### 步骤1：下载 JDK

1. 打开浏览器，访问：https://adoptium.net/temurin/releases/?version=17
2. 在页面中找到下载选项：
   - **Operating System（操作系统）**：选择 `Windows`
   - **Architecture（架构）**：选择 `x64`
   - **Package Type（包类型）**：选择 `JDK`
3. 点击蓝色的 `.msi` 下载按钮

#### 步骤2：安装 JDK

1. 双击下载的 `.msi` 文件
2. 点击 `Next`（下一步）
3. 选择安装路径（建议默认：`C:\Program Files\Eclipse Adoptium\jdk-17...`）
4. 点击 `Install`（安装）
5. 等待安装完成，点击 `Finish`（完成）

#### 步骤3：验证安装

1. 按 `Win + R` 键，输入 `cmd`，按回车打开命令提示符
2. 输入以下命令并按回车：
   ```
   java -version
   ```
3. 如果显示类似以下内容，说明安装成功：
   ```
   openjdk version "17.0.x" 2024-xx-xx
   OpenJDK Runtime Environment Temurin-17.0.x+x
   OpenJDK 64-Bit Server VM Temurin-17.0.x+x
   ```

#### 步骤4：配置环境变量（如果第3步失败才需要）

1. 右键点击"此电脑" → "属性"
2. 点击"高级系统设置"
3. 点击"环境变量"按钮
4. 在"系统变量"区域，点击"新建"：
   - 变量名：`JAVA_HOME`
   - 变量值：`C:\Program Files\Eclipse Adoptium\jdk-17`（你的JDK安装路径）
5. 找到系统变量中的 `Path`，点击"编辑"，点击"新建"，添加：
   ```
   %JAVA_HOME%\bin
   ```
6. 点击"确定"保存所有窗口
7. **重新打开**命令提示符，再次输入 `java -version` 验证

---

### 2.2 安装 MySQL 8.0

#### 步骤1：下载 MySQL

1. 访问：https://dev.mysql.com/downloads/installer/
2. 点击 `mysql-installer-community-8.0.xx.msi` 下载
3. 点击下方 `No thanks, just start my download`（不用登录直接下载）

#### 步骤2：安装 MySQL

1. 双击下载的 `.msi` 文件
2. 选择安装类型：选择 `Developer Default`（开发者默认），点击 `Next`
3. 点击 `Execute` 开始安装
4. 等待所有产品安装完成，点击 `Next`

#### 步骤3：配置 MySQL

1. **Type and Networking（类型和网络）**：
   - Config Type: `Development Computer`
   - Connectivity: 默认即可（Port: 3306）
   - 点击 `Next`

2. **Authentication Method（认证方法）**：
   - 选择 `Use Strong Password Encryption`
   - 点击 `Next`

3. **Accounts and Roles（账户和角色）**：
   - **MySQL Root Password（Root密码）**：输入一个你能记住的密码（例如：`root123456`）
   - **Repeat Password（重复密码）**：再次输入相同密码
   - ⚠️ **重要**：一定要记住这个密码！
   - 点击 `Next`

4. **Windows Service（Windows服务）**：
   - 勾选 `Configure MySQL Server as a Windows Service`
   - Service Name: `MySQL80`
   - 勾选 `Start the MySQL Server at System Startup`（开机自启）
   - 点击 `Next`

5. 点击 `Execute` 应用配置
6. 点击 `Finish` 完成配置

#### 步骤4：验证 MySQL 安装

1. 按 `Win + R`，输入 `cmd`，按回车
2. 输入：
   ```
   mysql -u root -p
   ```
3. 输入你设置的密码（输入时不会显示，直接输完按回车）
4. 如果看到 `mysql>` 提示符，说明安装成功
5. 输入 `exit` 退出

#### 步骤5：创建项目数据库

1. 打开命令提示符，登录 MySQL：
   ```
   mysql -u root -p
   ```
2. 输入密码后，复制粘贴以下命令（右键粘贴）：
   ```sql
   CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. 看到 `Query OK` 表示成功
4. 输入 `exit` 退出

---

### 2.3 安装 Redis（Windows）

#### 步骤1：下载 Redis

1. 访问：https://github.com/tporadowski/redis/releases
2. 找到最新版本，下载 `Redis-x64-xxx.zip`

#### 步骤2：安装 Redis

1. 右键下载的 zip 文件 → "解压到当前文件夹"或"解压到 Redis-x64-xxx"
2. 将解压后的文件夹移动到 `C:\Redis`（建议路径）

#### 步骤3：启动 Redis

1. 打开命令提示符（管理员模式）：
   - 按 `Win + X`，选择"Windows 终端（管理员）"或"命令提示符（管理员）"
2. 输入以下命令：
   ```
   cd C:\Redis
   redis-server.exe
   ```
3. 看到以下内容说明启动成功：
   ```
   [xxxx] * Ready to accept connections
   ```
4. **保持这个窗口打开**，Redis 需要一直运行

#### 步骤4：验证 Redis（新开一个命令提示符）

1. 按 `Win + R`，输入 `cmd`，打开新的命令提示符
2. 输入：
   ```
   cd C:\Redis
   redis-cli.exe ping
   ```
3. 如果返回 `PONG`，说明 Redis 正常运行

---

### 2.4 安装 Maven

#### 步骤1：下载 Maven

1. 访问：https://maven.apache.org/download.cgi
2. 找到 `Files` 区域，下载 `apache-maven-3.9.x-bin.zip`

#### 步骤2：安装 Maven

1. 解压下载的 zip 文件
2. 将解压后的文件夹移动到 `C:\Program Files\Apache\maven`

#### 步骤3：配置环境变量

1. 右键"此电脑" → "属性" → "高级系统设置" → "环境变量"
2. 在"系统变量"区域，点击"新建"：
   - 变量名：`MAVEN_HOME`
   - 变量值：`C:\Program Files\Apache\maven`
3. 找到系统变量中的 `Path`，点击"编辑"，点击"新建"，添加：
   ```
   %MAVEN_HOME%\bin
   ```
4. 点击"确定"保存所有窗口

#### 步骤4：验证安装

1. **重新打开**命令提示符
2. 输入：
   ```
   mvn -version
   ```
3. 如果显示版本信息，说明安装成功

---

### 2.5 下载项目代码

#### 方式一：使用 Git（推荐）

1. 安装 Git：https://git-scm.com/download/win
2. 打开命令提示符，输入：
   ```
   cd F:\Code_Project\Trae
   git clone https://github.com/MCG2053/AI-Anime-website-backend.git
   ```

#### 方式二：直接下载 ZIP

1. 访问：https://github.com/MCG2053/AI-Anime-website-backend
2. 点击绿色按钮 `Code` → `Download ZIP`
3. 解压到 `F:\Code_Project\Trae\Anime_website_backend`

---

## 第三部分：Ubuntu 环境搭建

### 3.1 准备工作

#### 步骤1：连接到服务器

如果你使用的是云服务器（阿里云、腾讯云等）：

**Windows 用户使用 PuTTY 或 Windows 终端：**
1. 打开 Windows 终端或 PowerShell
2. 输入：
   ```
   ssh root@你的服务器IP
   ```
3. 输入密码（输入时不会显示）

**如果你使用的是本地 Ubuntu 虚拟机：**
1. 直接打开终端（Ctrl + Alt + T）

#### 步骤2：更新系统

在终端中输入以下命令（复制粘贴即可）：

```bash
# 更新软件包列表
sudo apt update

# 升级已安装的软件包（过程中可能需要输入 y 确认）
sudo apt upgrade -y
```

---

### 3.2 安装 JDK 17

#### 步骤1：安装

```bash
sudo apt install -y openjdk-17-jdk
```

#### 步骤2：验证

```bash
java -version
```

应该显示：
```
openjdk version "17.0.x"
```

---

### 3.3 安装 MySQL 8.0

#### 步骤1：安装

```bash
sudo apt install -y mysql-server
```

#### 步骤2：启动服务

```bash
# 启动 MySQL
sudo systemctl start mysql

# 设置开机自启
sudo systemctl enable mysql

# 查看状态（应该显示 active (running)）
sudo systemctl status mysql
```

按 `q` 退出状态查看。

#### 步骤3：安全配置

```bash
sudo mysql_secure_installation
```

按照提示操作：

1. **Would you like to setup VALIDATE PASSWORD component?**
   - 输入 `n`（不需要密码强度验证）

2. **New password:**
   - 输入你想设置的密码（例如：`Root123456!`）
   - ⚠️ **记住这个密码！**

3. **Re-enter new password:**
   - 再次输入密码

4. **Remove anonymous users?**
   - 输入 `y`

5. **Disallow root login remotely?**
   - 输入 `y`

6. **Remove test database?**
   - 输入 `y`

7. **Reload privilege tables now?**
   - 输入 `y`

#### 步骤4：创建数据库和用户

```bash
# 登录 MySQL
sudo mysql -u root -p
```

输入密码后，在 `mysql>` 提示符下执行：

```sql
-- 创建数据库
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户（把 YourPassword123! 改成你想要的密码）
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'YourPassword123!';

-- 授权
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 退出
EXIT;
```

#### 步骤5：验证数据库创建

```bash
mysql -u anime_user -p -e "SHOW DATABASES;"
```

输入密码后，应该看到 `anime_website` 数据库。

---

### 3.4 安装 Redis

#### 步骤1：安装

```bash
sudo apt install -y redis-server
```

#### 步骤2：启动服务

```bash
# 启动 Redis
sudo systemctl start redis-server

# 设置开机自启
sudo systemctl enable redis-server

# 查看状态
sudo systemctl status redis-server
```

#### 步骤3：验证

```bash
redis-cli ping
```

应该返回 `PONG`。

---

### 3.5 安装 Maven

```bash
sudo apt install -y maven
```

验证：
```bash
mvn -version
```

---

### 3.6 下载项目代码

```bash
# 安装 git
sudo apt install -y git

# 进入目录
cd /opt

# 克隆项目
git clone https://github.com/MCG2053/AI-Anime-website-backend.git

# 进入项目目录
cd AI-Anime-website-backend
```

---

## 第四部分：CentOS 环境搭建

### 4.1 准备工作

#### 步骤1：连接到服务器

```bash
ssh root@你的服务器IP
```

#### 步骤2：更新系统

```bash
# CentOS 7
sudo yum update -y

# CentOS 8/9 / Rocky Linux / AlmaLinux
sudo dnf update -y
```

---

### 4.2 安装 JDK 17

```bash
# CentOS 7
sudo yum install -y java-17-openjdk java-17-openjdk-devel

# CentOS 8/9
sudo dnf install -y java-17-openjdk java-17-openjdk-devel
```

验证：
```bash
java -version
```

---

### 4.3 安装 MySQL 8.0

#### 步骤1：添加 MySQL 仓库

```bash
# CentOS 7
sudo yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm

# CentOS 8
sudo dnf localinstall -y https://dev.mysql.com/get/mysql80-community-release-el8-7.noarch.rpm

# CentOS 9 / Rocky 9
sudo dnf localinstall -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
```

#### 步骤2：安装 MySQL

```bash
# CentOS 7
sudo yum install -y mysql-community-server

# CentOS 8/9
sudo dnf install -y mysql-community-server
```

#### 步骤3：启动服务

```bash
# 启动 MySQL
sudo systemctl start mysqld

# 设置开机自启
sudo systemctl enable mysqld

# 查看状态
sudo systemctl status mysqld
```

#### 步骤4：获取临时密码

```bash
sudo grep 'temporary password' /var/log/mysqld.log
```

会显示类似：
```
2024-01-01T00:00:00.000000Z 1 [Note] A temporary password is generated for root@localhost: Ab3#xYz9Kp
```

记住最后的密码（`Ab3#xYz9Kp` 这样的字符串）。

#### 步骤5：修改密码

```bash
mysql -u root -p
```

输入临时密码后：

```sql
-- 修改密码（密码需要包含大小写字母、数字、特殊符号）
ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword123!';

-- 创建数据库
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户
CREATE USER 'anime_user'@'localhost' IDENTIFIED BY 'YourPassword123!';

-- 授权
GRANT ALL PRIVILEGES ON anime_website.* TO 'anime_user'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 退出
EXIT;
```

---

### 4.4 安装 Redis

```bash
# CentOS 7
sudo yum install -y epel-release
sudo yum install -y redis

# CentOS 8/9
sudo dnf install -y redis
```

启动服务：
```bash
sudo systemctl start redis
sudo systemctl enable redis
sudo systemctl status redis
```

验证：
```bash
redis-cli ping
```

---

### 4.5 安装 Maven

```bash
# CentOS 7
sudo yum install -y maven

# CentOS 8/9
sudo dnf install -y maven
```

---

### 4.6 下载项目代码

```bash
sudo yum install -y git    # CentOS 7
sudo dnf install -y git    # CentOS 8/9

cd /opt
git clone https://github.com/MCG2053/AI-Anime-website-backend.git
cd AI-Anime-website-backend
```

---

## 第五部分：项目配置详解

### 5.1 找到配置文件

配置文件位置：`src/main/resources/application.yml`

### 5.2 配置文件详细说明

用文本编辑器打开配置文件：

**Windows：**
```
用记事本或 VS Code 打开
F:\Code_Project\Trae\Anime_website_backend\src\main\resources\application.yml
```

**Linux：**
```bash
vim src/main/resources/application.yml
# 或
nano src/main/resources/application.yml
```

### 5.3 需要修改的内容

```yaml
spring:
  application:
    name: anime-website-backend
  
  datasource:
    # 数据库连接地址（一般不需要改）
    url: jdbc:mysql://localhost:3306/anime_website?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    
    # ⚠️ 修改这里：你的 MySQL 用户名
    username: root          # 如果创建了 anime_user，改成 anime_user
    
    # ⚠️ 修改这里：你的 MySQL 密码
    password: root          # 改成你设置的密码
    
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  jpa:
    hibernate:
      ddl-auto: update      # 自动创建/更新表结构
    show-sql: false         # 是否显示 SQL 语句（开发时可改为 true）
  
  data:
    redis:
      host: localhost       # Redis 地址（本地就是 localhost）
      port: 6379            # Redis 端口（默认 6379）
      password:              # Redis 密码（如果设置了就填写）
      database: 0

server:
  port: 8080                # 后端服务端口（可以改成其他端口）

jwt:
  # ⚠️ 生产环境建议修改这个密钥（至少 32 个字符）
  secret: animeWebsiteSecretKeyForJWT2024VeryLongSecretKeyForSecurity
  expiration: 86400000      # Token 有效期（毫秒），默认 24 小时
```

### 5.4 配置示例

假设你设置的 MySQL 密码是 `MyPassword123!`，配置文件应该改成：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/anime_website?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    username: root
    password: MyPassword123!
```

### 5.5 保存配置文件

**Windows 记事本：** Ctrl + S 保存

**Linux vim：**
1. 按 `Esc` 键
2. 输入 `:wq`
3. 按 `Enter` 键

**Linux nano：**
1. Ctrl + O 保存
2. Enter 确认
3. Ctrl + X 退出

---

## 第六部分：启动项目

### 6.1 Windows 启动

#### 步骤1：打开命令提示符

按 `Win + R`，输入 `cmd`，按回车

#### 步骤2：进入项目目录

```
cd F:\Code_Project\Trae\Anime_website_backend
```

#### 步骤3：确保 Redis 正在运行

打开另一个命令提示符窗口：
```
cd C:\Redis
redis-server.exe
```
保持这个窗口打开！

#### 步骤4：启动项目

回到第一个命令提示符窗口：
```
mvn spring-boot:run
```

#### 步骤5：等待启动

第一次启动会下载依赖，需要等待几分钟。

看到以下内容表示启动成功：
```
Started AnimeWebsiteBackendApplication in X.XXX seconds
```

### 6.2 Ubuntu 启动

#### 步骤1：进入项目目录

```bash
cd /opt/AI-Anime-website-backend
```

#### 步骤2：确保服务运行

```bash
# 检查 MySQL
sudo systemctl status mysql

# 检查 Redis
sudo systemctl status redis-server
```

#### 步骤3：启动项目

```bash
mvn spring-boot:run
```

### 6.3 CentOS 启动

```bash
cd /opt/AI-Anime-website-backend

# 检查服务
sudo systemctl status mysqld
sudo systemctl status redis

# 启动
mvn spring-boot:run
```

### 6.4 后台运行（Linux 服务器推荐）

如果想让项目在后台运行，即使关闭终端也不会停止：

```bash
# 编译打包
mvn clean package -DskipTests

# 后台运行
nohup java -jar target/anime-website-backend-1.0.0.jar > app.log 2>&1 &

# 查看日志
tail -f app.log

# 查看进程
ps aux | grep java

# 停止项目
kill $(pgrep -f anime-website-backend)
```

---

## 第七部分：常见错误解决

### 错误1：找不到或无法加载主类

**错误信息：**
```
错误: 找不到或无法加载主类 com.anime.website.AnimeWebsiteBackendApplication
```

**解决方法：**
```bash
# 清理并重新编译
mvn clean compile
```

---

### 错误2：数据库连接失败

**错误信息：**
```
Communications link failure
java.net.ConnectException: Connection refused
```

**原因：** MySQL 没有启动或连接信息错误

**解决步骤：**

1. **检查 MySQL 是否运行**
   ```bash
   # Windows
   net start | findstr MySQL
   
   # Ubuntu
   sudo systemctl status mysql
   
   # CentOS
   sudo systemctl status mysqld
   ```

2. **如果没运行，启动 MySQL**
   ```bash
   # Windows（管理员权限）
   net start MySQL80
   
   # Ubuntu
   sudo systemctl start mysql
   
   # CentOS
   sudo systemctl start mysqld
   ```

3. **检查配置文件中的用户名密码**
   - 打开 `application.yml`
   - 确认 `username` 和 `password` 是否正确

4. **测试数据库连接**
   ```bash
   mysql -u root -p
   # 输入密码，看能否登录
   ```

---

### 错误3：Redis 连接失败

**错误信息：**
```
Unable to connect to Redis
io.lettuce.core.RedisConnectionException
```

**解决步骤：**

1. **检查 Redis 是否运行**
   ```bash
   # Windows
   # 打开命令提示符
   cd C:\Redis
   redis-cli.exe ping
   
   # Ubuntu
   sudo systemctl status redis-server
   redis-cli ping
   
   # CentOS
   sudo systemctl status redis
   redis-cli ping
   ```

2. **如果没运行，启动 Redis**
   ```bash
   # Windows
   cd C:\Redis
   redis-server.exe
   
   # Ubuntu
   sudo systemctl start redis-server
   
   # CentOS
   sudo systemctl start redis
   ```

3. **暂时禁用 Redis（如果暂时不需要）**
   
   修改 `application.yml`：
   ```yaml
   spring:
     data:
       redis:
         host: localhost
         port: 6379
   ```
   
   或者在代码中暂时注释掉 Redis 相关配置。

---

### 错误4：端口被占用

**错误信息：**
```
Web server failed to start. Port 8080 was already in use.
```

**解决步骤：**

1. **查看端口占用**
   ```bash
   # Windows
   netstat -ano | findstr :8080
   
   # Linux
   sudo lsof -i :8080
   # 或
   sudo netstat -tlnp | grep 8080
   ```

2. **杀掉占用进程**
   ```bash
   # Windows（PID 是上面查到的进程ID）
   taskkill /F /PID 进程ID
   
   # Linux
   sudo kill -9 进程ID
   ```

3. **或者换端口**
   
   修改 `application.yml`：
   ```yaml
   server:
     port: 8081    # 改成其他端口
   ```

---

### 错误5：编译失败

**错误信息：**
```
COMPILATION ERROR
找不到符号
```

**解决步骤：**

1. **清理并重新编译**
   ```bash
   mvn clean compile
   ```

2. **检查 JDK 版本**
   ```bash
   java -version
   # 应该是 17 或以上
   ```

3. **更新 Maven 依赖**
   ```bash
   mvn dependency:resolve
   ```

---

### 错误6：访问被拒绝

**错误信息：**
```
Access denied for user 'root'@'localhost'
```

**解决步骤：**

1. **重置 MySQL 密码**
   ```bash
   # 登录 MySQL
   sudo mysql -u root
   
   # 执行（把新密码改成你的密码）
   ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';
   FLUSH PRIVILEGES;
   EXIT;
   ```

2. **更新配置文件**
   
   把 `application.yml` 中的密码改成新密码。

---

### 错误7：表不存在

**错误信息：**
```
Table 'anime_website.users' doesn't exist
```

**解决步骤：**

这是因为数据库表还没创建。

1. **确保配置正确**
   ```yaml
   spring:
     jpa:
       hibernate:
         ddl-auto: update    # 确保是 update 或 create
   ```

2. **重启项目**
   
   项目启动时会自动创建表。

---

### 错误8：内存不足

**错误信息：**
```
Java heap space
OutOfMemoryError
```

**解决步骤：**

增加 JVM 内存：

```bash
# Windows
set JAVA_OPTS=-Xms512m -Xmx1024m
mvn spring-boot:run

# Linux
export JAVA_OPTS="-Xms512m -Xmx1024m"
mvn spring-boot:run
```

或者运行 jar 包时：
```bash
java -Xms512m -Xmx1024m -jar target/anime-website-backend-1.0.0.jar
```

---

### 错误9：Maven 下载依赖慢

**解决方法：配置国内镜像**

1. **找到 Maven 配置文件**
   - Windows: `C:\Program Files\Apache\maven\conf\settings.xml`
   - Linux: `/etc/maven/settings.xml`

2. **添加阿里云镜像**
   
   在 `<mirrors>` 标签内添加：
   ```xml
   <mirror>
     <id>aliyun</id>
     <mirrorOf>central</mirrorOf>
     <name>Aliyun Maven Mirror</name>
     <url>https://maven.aliyun.com/repository/public</url>
   </mirror>
   ```

---

### 错误10：防火墙阻止访问

**症状：** 本地能访问，其他电脑无法访问

**解决步骤：**

**Windows：**
1. 控制面板 → Windows Defender 防火墙 → 高级设置
2. 入站规则 → 新建规则 → 端口 → TCP → 特定端口：8080
3. 允许连接 → 完成

**Ubuntu：**
```bash
sudo ufw allow 8080/tcp
sudo ufw reload
```

**CentOS：**
```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

---

## 第八部分：测试验证

### 8.1 检查服务是否启动

**方法1：浏览器访问**

打开浏览器，访问：
```
http://localhost:8080/swagger-ui.html
```

如果看到 Swagger 文档页面，说明启动成功！

**方法2：命令行测试**

```bash
# Windows（PowerShell）
Invoke-WebRequest http://localhost:8080/api/videos

# Linux
curl http://localhost:8080/api/videos
```

如果返回 JSON 数据，说明正常。

### 8.2 导入测试数据

```bash
# Windows
mysql -u root -p anime_website < F:\Code_Project\Trae\Anime_website_backend\docs\init_data.sql

# Linux
mysql -u anime_user -p anime_website < /opt/AI-Anime-website-backend/docs/init_data.sql
```

### 8.3 测试 API

#### 测试1：获取视频列表

浏览器访问：
```
http://localhost:8080/api/videos
```

应该返回类似：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [...],
    "total": 18,
    "page": 1,
    "pageSize": 20
  }
}
```

#### 测试2：用户注册

使用 Postman 或 curl：

```bash
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"123456"}'
```

应该返回：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJ...",
    "user": {...}
  }
}
```

### 8.4 前端对接

修改前端项目的 `.env.development` 文件：

```env
VITE_API_BASE_URL=http://localhost:8080/api
```

启动前端：
```bash
cd 前端项目目录
npm install
npm run dev
```

---

## 🎉 恭喜！

如果你看到这里，并且所有测试都通过了，说明后端已经成功运行！

接下来你可以：
1. 访问 Swagger 文档查看所有 API
2. 使用 Postman 测试各个接口
3. 启动前端项目进行联调

如有问题，请查看 [常见错误解决](#第七部分常见错误解决) 部分。
