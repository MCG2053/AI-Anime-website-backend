# Anime Website Backend API  

English | [简体中文](./README.md) 

A Spring Boot 3 based backend service for anime website, providing complete features including user authentication, video management, comments, danmaku, etc.

## Tech Stack

- **Java 17**
- **Spring Boot 3.2.1**
- **Spring Security** - Security framework
- **Spring Data JPA** - Data persistence
- **MySQL** - Database
- **Redis** - Cache
- **JWT** - Authentication
- **Swagger/OpenAPI** - API documentation

## Features

### User Module
- User registration, login, logout
- JWT Token authentication
- User profile management (avatar, bio, password change)
- User statistics
- Like and collection records

### Video Module
- Video list (filter by category, year, country)
- Video details
- Video search
- Popular videos, latest videos
- Recommended videos
- Weekly schedule
- Video like and collection

### Comment Module
- Post comments
- Comment replies
- Comment likes
- Delete comments

### Danmaku Module
- Send danmaku
- Get danmaku list

### Anime List Module
- Add/remove anime list
- Anime status management
- Watch history

## Quick Start

### Requirements

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+

### Configuration

1. Clone the project
```bash
git clone https://github.com/MCG2053/AI-Anime-website-backend.git
cd AI-Anime-website-backend
```

2. Create database
```sql
CREATE DATABASE anime_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. Modify configuration file `src/main/resources/application.yml`
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

4. Build and run
```bash
mvn clean install
mvn spring-boot:run
```

### API Documentation

After starting the project, visit:
- Swagger UI: http://localhost:8080/swagger-ui.html
- API Docs: http://localhost:8080/api-docs

## API Endpoints

### Basic Information
- **Base URL**: `/api`
- **Authentication**: JWT Token
- **Request Header**: `Authorization: Bearer <token>`

### Main Endpoints

| Module | Method | Path | Description |
|--------|--------|------|-------------|
| User | POST | /user/login | User login |
| User | POST | /user/register | User registration |
| User | GET | /user/info | Get user info |
| Video | GET | /videos | Get video list |
| Video | GET | /videos/{id} | Get video details |
| Video | GET | /search | Search videos |
| Comment | GET | /videos/{videoId}/comments | Get comment list |
| Comment | POST | /comments | Post comment |
| Danmaku | GET | /videos/{videoId}/danmaku | Get danmaku |
| Danmaku | POST | /danmaku | Send danmaku |

## Project Structure

```
src/main/java/com/anime/website/
├── config/          # Configuration classes
├── controller/      # Controllers
├── dto/             # Data Transfer Objects
├── entity/          # Entity classes
├── exception/       # Exception handling
├── repository/      # Data access layer
├── security/        # Security related
└── service/         # Business logic layer
```

## Response Format

### Success Response
```json
{
  "code": 0,
  "message": "success",
  "data": { ... }
}
```

### Error Response
```json
{
  "code": 400,
  "message": "Error message",
  "data": null
}
```

## Error Codes

| Code | Description |
|------|-------------|
| 0 | Success |
| 400 | Bad Request |
| 401 | Unauthorized/Token Expired |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Server Error |

## Development Guide

### Branch Management
- `main`: Production stable branch, direct push prohibited
- `develop`: Development integration branch
- `feature/xxx`: Feature development branch
- `bugfix/xxx`: Bug fix branch

### Commit Convention
```
<type>(<scope>): <subject>

<body>
```

type:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Refactoring
- `test`: Testing
- `chore`: Build/tools

## License

[MIT License](LICENSE)

## Related Projects

- Frontend Project: [Anime_Website](https://github.com/MCG2053/AI-Anime-website)
