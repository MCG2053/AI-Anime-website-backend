# 动漫网站后端 API  

[English](./README.en.md) | 简体中文 

一个基于 Spring Boot 3 的动漫网站后端服务，提供完整的用户认证、视频管理、评论、弹幕等功能。

## 技术栈

- **Java 17**
- **Spring Boot 3.2.1**
- **Spring Security** - 安全框架
- **Spring Data JPA** - 数据持久化
- **MySQL** - 数据库
- **Redis** - 缓存
- **JWT** - 身份认证
- **Swagger/OpenAPI** - API 文档

## 功能特性

### 用户模块
- 用户注册、登录、登出
- JWT Token 认证
- 用户信息管理（头像、简介、密码修改）
- 用户统计数据
- 点赞和收藏记录

### 视频模块
- 视频列表（支持分类、年份、国家筛选）
- 视频详情
- 视频搜索
- 热门视频、最新视频
- 推荐视频
- 周更时间表
- 视频点赞和收藏

### 评论模块
- 发表评论
- 评论回复
- 评论点赞
- 删除评论

### 弹幕模块
- 发送弹幕
- 获取弹幕列表

### 追番模块
- 添加/移除追番
- 追番状态管理
- 观看历史记录

## 快速开始

### 环境要求

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+

### 配置

1. 克隆项目
```bash
git clone https://github.com/MCG2053/AI-Anime-website-backend.git
cd AI-Anime-website-backend
```

2. 创建数据库
```sql
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. 修改配置文件 `src/main/resources/application.yml`
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/anime_website
    username: your_username
    password: your_password
  data:
    redis:
      host: localhost
      port: 6379
```

4. 构建并运行
```bash
mvn clean install
mvn spring-boot:run
```

### API 文档

启动项目后访问：
- Swagger UI: http://localhost:8080/swagger-ui.html
- API Docs: http://localhost:8080/api-docs

## API 接口

### 基础信息
- **Base URL**: `/api`
- **认证方式**: JWT Token
- **请求头**: `Authorization: Bearer <token>`

### 主要接口

| 模块 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 用户 | POST | /user/login | 用户登录 |
| 用户 | POST | /user/register | 用户注册 |
| 用户 | GET | /user/info | 获取用户信息 |
| 视频 | GET | /videos | 获取视频列表 |
| 视频 | GET | /videos/{id} | 获取视频详情 |
| 视频 | GET | /search | 搜索视频 |
| 评论 | GET | /videos/{videoId}/comments | 获取评论列表 |
| 评论 | POST | /comments | 发表评论 |
| 弹幕 | GET | /videos/{videoId}/danmaku | 获取弹幕 |
| 弹幕 | POST | /danmaku | 发送弹幕 |

## 项目结构

```
src/main/java/com/anime/website/
├── config/          # 配置类
├── controller/      # 控制器
├── dto/             # 数据传输对象
├── entity/          # 实体类
├── exception/       # 异常处理
├── repository/      # 数据访问层
├── security/        # 安全相关
└── service/         # 业务逻辑层
```

## 响应格式

### 成功响应
```json
{
  "code": 0,
  "message": "success",
  "data": { ... }
}
```

### 错误响应
```json
{
  "code": 400,
  "message": "错误信息",
  "data": null
}
```

## 错误码

| 错误码 | 说明 |
|--------|------|
| 0 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权/Token过期 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器错误 |

## 开发指南

### 分支管理
- `main`: 生产稳定分支，禁止直接推送
- `develop`: 开发集成分支
- `feature/xxx`: 功能开发分支
- `bugfix/xxx`: 修复分支

### 提交规范
```
<type>(<scope>): <subject>

<body>
```

type 类型：
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `style`: 格式
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

## 许可证

[MIT License](LICENSE)

## 相关项目

- 前端项目: [Anime_Website](https://github.com/MCG2053/AI-Anime-website)
