# API 测试文档

## 测试环境

- **Base URL**: `http://localhost:8080/api`
- **认证方式**: JWT Token
- **请求头**: `Authorization: Bearer <token>`

## 测试工具

推荐使用以下工具进行API测试：
- Postman
- curl
- Swagger UI (访问地址: `http://localhost:8080/api/swagger-ui.html`)

---

## 一、用户认证接口测试

### 1.1 用户注册

**接口**: `POST /api/user/register`

**测试用例 1: 正常注册**
```bash
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test123456"
  }'
```

**预期结果**:
- 状态码: 200
- 返回包含 token 和 user 信息
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "user": {
      "id": 1,
      "username": "testuser",
      "email": "test@example.com",
      "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=test@example.com",
      "bio": null,
      "createdAt": "2024-01-01T00:00:00",
      "likeCount": 0,
      "commentCount": 0,
      "animeCount": 0,
      "historyCount": 0
    }
  }
}
```

**测试用例 2: 重复邮箱注册**
```bash
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser2",
    "email": "test@example.com",
    "password": "Test123456"
  }'
```

**预期结果**:
- 状态码: 200
- code: 非0
- message: "邮箱已被注册"

**测试用例 3: 缺少必填字段**
```bash
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser"
  }'
```

**预期结果**:
- 状态码: 400
- 返回参数验证错误信息

---

### 1.2 用户登录

**接口**: `POST /api/user/login`

**测试用例 1: 正确凭据登录**
```bash
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123456"
  }'
```

**预期结果**:
- 状态码: 200
- 返回包含 token 和 user 信息

**测试用例 2: 错误密码**
```bash
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "wrongpassword"
  }'
```

**预期结果**:
- 状态码: 200
- code: 非0
- message: "邮箱或密码错误"

**测试用例 3: 不存在的用户**
```bash
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "nonexistent@example.com",
    "password": "Test123456"
  }'
```

**预期结果**:
- 状态码: 200
- code: 非0
- message: "邮箱或密码错误"

---

### 1.3 用户登出

**接口**: `POST /api/user/logout`

**测试用例 1: 已认证用户登出**
```bash
curl -X POST http://localhost:8080/api/user/logout \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
- 状态码: 200
```json
{
  "code": 0,
  "message": "success",
  "data": null
}
```

---

## 二、用户信息接口测试

### 2.1 获取用户信息

**接口**: `GET /api/user/info`

**测试用例 1: 已认证用户获取信息**
```bash
curl -X GET http://localhost:8080/api/user/info \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
- 状态码: 200
- 返回用户详细信息

**测试用例 2: 未认证访问**
```bash
curl -X GET http://localhost:8080/api/user/info
```

**预期结果**:
- 状态码: 401

---

### 2.2 更新用户信息

**接口**: `PUT /api/user/info`

**测试用例 1: 更新用户名和简介**
```bash
curl -X PUT http://localhost:8080/api/user/info \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newusername",
    "bio": "这是我的个人简介"
  }'
```

**预期结果**:
- 状态码: 200
- 返回更新后的用户信息

---

### 2.3 更新头像

**接口**: `PUT /api/user/avatar`

**测试用例 1: 更新头像URL**
```bash
curl -X PUT http://localhost:8080/api/user/avatar \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "avatar": "https://example.com/avatar.png"
  }'
```

**预期结果**:
- 状态码: 200
- 返回更新后的用户信息

---

### 2.4 修改密码

**接口**: `PUT /api/user/password`

**测试用例 1: 正确修改密码**
```bash
curl -X PUT http://localhost:8080/api/user/password \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "oldPassword": "Test123456",
    "newPassword": "NewTest123456"
  }'
```

**预期结果**:
- 状态码: 200

**测试用例 2: 旧密码错误**
```bash
curl -X PUT http://localhost:8080/api/user/password \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "oldPassword": "wrongpassword",
    "newPassword": "NewTest123456"
  }'
```

**预期结果**:
- 状态码: 200
- code: 非0
- message: "旧密码不正确"

---

### 2.5 获取用户统计数据

**接口**: `GET /api/user/stats`

**测试用例 1: 获取统计数据**
```bash
curl -X GET http://localhost:8080/api/user/stats \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "likeCount": 5,
    "commentCount": 10,
    "animeCount": 3,
    "historyCount": 20,
    "watchTime": 0
  }
}
```

---

### 2.6 获取用户点赞记录

**接口**: `GET /api/user/likes`

**测试用例 1: 获取点赞记录**
```bash
curl -X GET http://localhost:8080/api/user/likes \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "videoIds": [1, 2, 3],
    "commentIds": [1, 2]
  }
}
```

---

### 2.7 获取用户收藏记录

**接口**: `GET /api/user/collections`

**测试用例 1: 获取收藏记录**
```bash
curl -X GET http://localhost:8080/api/user/collections \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "videoIds": [1, 2, 3]
  }
}
```

---

### 2.8 获取用户评论列表

**接口**: `GET /api/user/comments`

**测试用例 1: 获取用户评论列表**
```bash
curl -X GET "http://localhost:8080/api/user/comments?page=1&pageSize=20" \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "userId": 1,
        "username": "testuser",
        "avatar": "https://...",
        "content": "这是一条评论",
        "likeCount": 5,
        "createdAt": "2024-01-01T00:00:00",
        "replies": []
      }
    ],
    "total": 10,
    "page": 1,
    "pageSize": 20
  }
}
```

---

## 三、追番接口测试

### 3.1 获取追番列表

**接口**: `GET /api/user/anime-list`

**测试用例 1: 获取追番列表**
```bash
curl -X GET http://localhost:8080/api/user/anime-list \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "watching": [],
    "completed": [],
    "history": []
  }
}
```

---

### 3.2 添加追番

**接口**: `POST /api/user/anime`

**测试用例 1: 添加追番**
```bash
curl -X POST http://localhost:8080/api/user/anime \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "videoId": 1,
    "status": "watching"
  }'
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 3.3 移除追番

**接口**: `DELETE /api/user/anime/{videoId}`

**测试用例 1: 移除追番**
```bash
curl -X DELETE http://localhost:8080/api/user/anime/1 \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 3.4 更新追番状态

**接口**: `PUT /api/user/anime/{videoId}`

**测试用例 1: 更新为已完成**
```bash
curl -X PUT http://localhost:8080/api/user/anime/1 \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed"
  }'
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

## 四、观看历史接口测试

### 4.1 获取观看历史

**接口**: `GET /api/user/history`

**测试用例 1: 分页获取观看历史**
```bash
curl -X GET "http://localhost:8080/api/user/history?page=1&pageSize=20" \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "videoId": 1,
        "episodeId": 1,
        "episodeTitle": "第1集",
        "watchedAt": "2024-01-01T00:00:00",
        "progress": 120,
        "video": {...}
      }
    ],
    "total": 10
  }
}
```

---

### 4.2 更新观看进度

**接口**: `POST /api/user/history`

**测试用例 1: 更新观看进度**
```bash
curl -X POST http://localhost:8080/api/user/history \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "videoId": 1,
    "episodeId": 1,
    "episodeTitle": "第1集",
    "progress": 120
  }'
```

**预期结果**:
- 状态码: 200

---

### 4.3 删除观看历史

**接口**: `DELETE /api/user/history/{videoId}`

**测试用例 1: 删除单条观看历史**
```bash
curl -X DELETE http://localhost:8080/api/user/history/1 \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 4.4 清空观看历史

**接口**: `DELETE /api/user/history`

**测试用例 1: 清空所有观看历史**
```bash
curl -X DELETE http://localhost:8080/api/user/history \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

## 五、视频接口测试

### 5.1 获取视频列表

**接口**: `GET /api/videos`

**测试用例 1: 获取所有视频**
```bash
curl -X GET "http://localhost:8080/api/videos?page=1&pageSize=20"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [...],
    "total": 100,
    "page": 1,
    "pageSize": 20
  }
}
```

**测试用例 2: 按分类筛选**
```bash
curl -X GET "http://localhost:8080/api/videos?category=番剧&page=1&pageSize=20"
```

**测试用例 3: 按年份筛选**
```bash
curl -X GET "http://localhost:8080/api/videos?year=2024&page=1&pageSize=20"
```

---

### 5.2 获取视频详情

**接口**: `GET /api/videos/{id}`

**测试用例 1: 获取视频详情**
```bash
curl -X GET http://localhost:8080/api/videos/1
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "title": "视频标题",
    "cover": "https://...",
    "description": "视频描述",
    "playCount": 1000,
    "likeCount": 100,
    "collectCount": 50,
    "episode": "更新至第12集",
    "category": "番剧",
    "tags": ["热血", "冒险"],
    "country": "日本",
    "year": 2024,
    "videoUrl": "https://...",
    "episodes": [
      {
        "id": 1,
        "title": "第1集",
        "videoUrl": "https://...",
        "duration": 1440
      }
    ],
    "relatedVideos": [...]
  }
}
```

---

### 5.3 获取视频点赞/收藏状态

**接口**: `GET /api/videos/{id}/status`

**测试用例 1: 获取状态（已登录）**
```bash
curl -X GET http://localhost:8080/api/videos/1/status \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "isLiked": false,
    "isCollected": false
  }
}
```

---

### 5.4 点赞视频

**接口**: `POST /api/videos/{id}/like`

**测试用例 1: 点赞视频**
```bash
curl -X POST http://localhost:8080/api/videos/1/like \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 5.5 取消点赞

**接口**: `DELETE /api/videos/{id}/like`

**测试用例 1: 取消点赞**
```bash
curl -X DELETE http://localhost:8080/api/videos/1/like \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 5.6 收藏视频

**接口**: `POST /api/videos/{id}/collect`

**测试用例 1: 收藏视频**
```bash
curl -X POST http://localhost:8080/api/videos/1/collect \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 5.7 取消收藏

**接口**: `DELETE /api/videos/{id}/collect`

**测试用例 1: 取消收藏**
```bash
curl -X DELETE http://localhost:8080/api/videos/1/collect \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 5.8 获取推荐视频

**接口**: `GET /api/videos/{id}/recommendations`

**测试用例 1: 获取推荐视频**
```bash
curl -X GET "http://localhost:8080/api/videos/1/recommendations?limit=6"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [...]
}
```

---

### 5.9 获取热门视频

**接口**: `GET /api/videos/popular`

**测试用例 1: 获取热门视频**
```bash
curl -X GET "http://localhost:8080/api/videos/popular?limit=10"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [...]
}
```

---

### 5.10 获取最新视频

**接口**: `GET /api/videos/latest`

**测试用例 1: 获取最新视频**
```bash
curl -X GET "http://localhost:8080/api/videos/latest?limit=10"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [...]
}
```

---

### 5.11 获取周更时间表

**接口**: `GET /api/videos/schedule`

**测试用例 1: 获取周更时间表**
```bash
curl -X GET http://localhost:8080/api/videos/schedule
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "周一": [...],
    "周二": [...],
    "周三": [...],
    "周四": [...],
    "周五": [...],
    "周六": [...],
    "周日": [...]
  }
}
```

---

### 5.12 增加播放次数

**接口**: `POST /api/videos/{id}/play`

**测试用例 1: 增加播放次数**
```bash
curl -X POST http://localhost:8080/api/videos/1/play
```

**预期结果**:
- 状态码: 200

---

## 六、评论接口测试

### 6.1 获取视频评论

**接口**: `GET /api/videos/{videoId}/comments`

**测试用例 1: 分页获取评论**
```bash
curl -X GET "http://localhost:8080/api/videos/1/comments?page=1&pageSize=20"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "userId": 1,
        "username": "testuser",
        "avatar": "https://...",
        "content": "这是一条评论",
        "likeCount": 5,
        "createdAt": "2024-01-01T00:00:00",
        "replies": [...]
      }
    ],
    "total": 100
  }
}
```

---

### 6.2 发表评论

**接口**: `POST /api/comments`

**测试用例 1: 发表一级评论**
```bash
curl -X POST http://localhost:8080/api/comments \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "videoId": 1,
    "content": "这是一条评论"
  }'
```

**预期结果**:
- 状态码: 200
- 返回评论详情

**测试用例 2: 发表回复评论**
```bash
curl -X POST http://localhost:8080/api/comments \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "videoId": 1,
    "content": "这是一条回复",
    "parentId": 1
  }'
```

---

### 6.3 点赞评论

**接口**: `POST /api/comments/{id}/like`

**测试用例 1: 点赞评论**
```bash
curl -X POST http://localhost:8080/api/comments/1/like \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 6.4 取消点赞评论

**接口**: `DELETE /api/comments/{id}/like`

**测试用例 1: 取消点赞**
```bash
curl -X DELETE http://localhost:8080/api/comments/1/like \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 6.5 删除评论

**接口**: `DELETE /api/comments/{id}`

**测试用例 1: 删除自己的评论**
```bash
curl -X DELETE http://localhost:8080/api/comments/1 \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

## 七、弹幕接口测试

### 7.1 获取弹幕列表

**接口**: `GET /api/videos/{videoId}/danmaku`

**测试用例 1: 获取视频所有弹幕**
```bash
curl -X GET http://localhost:8080/api/videos/1/danmaku
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [
    {
      "id": 1,
      "content": "这是一条弹幕",
      "time": 10.5,
      "color": "#ffffff",
      "type": "scroll",
      "userId": 1,
      "createdAt": "2024-01-01T00:00:00"
    }
  ]
}
```

**测试用例 2: 获取指定集数弹幕**
```bash
curl -X GET "http://localhost:8080/api/videos/1/danmaku?episodeId=1"
```

---

### 7.2 按集数获取弹幕

**接口**: `GET /api/videos/{videoId}/episodes/{episodeId}/danmaku`

**测试用例 1: 获取指定集数弹幕**
```bash
curl -X GET http://localhost:8080/api/videos/1/episodes/1/danmaku
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [...]
}
```

---

### 7.3 批量获取弹幕

**接口**: `POST /api/danmaku/batch`

**测试用例 1: 批量获取多集弹幕**
```bash
curl -X POST http://localhost:8080/api/danmaku/batch \
  -H "Content-Type: application/json" \
  -d '{
    "videoId": 1,
    "episodeIds": [1, 2, 3]
  }'
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "1": [...],
    "2": [...],
    "3": [...]
  }
}
```

---

### 7.4 发送弹幕

**接口**: `POST /api/danmaku`

**测试用例 1: 发送滚动弹幕**
```bash
curl -X POST http://localhost:8080/api/danmaku \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "videoId": 1,
    "episodeId": 1,
    "content": "这是一条弹幕",
    "time": 10.5,
    "color": "#ffffff",
    "type": "scroll"
  }'
```

**预期结果**:
- 状态码: 200
- 返回弹幕详情

---

### 7.5 删除弹幕

**接口**: `DELETE /api/danmaku/{danmakuId}`

**测试用例 1: 删除自己的弹幕**
```bash
curl -X DELETE http://localhost:8080/api/danmaku/1 \
  -H "Authorization: Bearer <token>"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

### 7.6 获取弹幕统计

**接口**: `GET /api/videos/{videoId}/danmaku/stats`

**测试用例 1: 获取视频弹幕统计**
```bash
curl -X GET http://localhost:8080/api/videos/1/danmaku/stats
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 100,
    "scrollCount": 80,
    "topCount": 10,
    "bottomCount": 10
  }
}
```

**测试用例 2: 获取指定集数弹幕统计**
```bash
curl -X GET "http://localhost:8080/api/videos/1/danmaku/stats?episodeId=1"
```

---

### 7.7 举报弹幕

**接口**: `POST /api/danmaku/{danmakuId}/report`

**测试用例 1: 举报弹幕**
```bash
curl -X POST http://localhost:8080/api/danmaku/1/report \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "reason": "违规内容"
  }'
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "success": true
  }
}
```

---

## 八、搜索接口测试

### 8.1 搜索视频

**接口**: `GET /api/search`

**测试用例 1: 关键词搜索**
```bash
curl -X GET "http://localhost:8080/api/search?keyword=火影&page=1&pageSize=20"
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [...],
    "total": 10,
    "page": 1,
    "pageSize": 20
  }
}
```

---

## 九、分类和标签接口测试

### 9.1 获取分类列表

**接口**: `GET /api/categories`

**测试用例 1: 获取所有分类**
```bash
curl -X GET http://localhost:8080/api/categories
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "番剧",
      "slug": "bangumi",
      "icon": "..."
    }
  ]
}
```

---

### 9.2 获取标签列表

**接口**: `GET /api/tags`

**测试用例 1: 获取所有标签**
```bash
curl -X GET http://localhost:8080/api/tags
```

**预期结果**:
```json
{
  "code": 0,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "热血",
      "type": "genre"
    }
  ]
}
```

---

## 十、错误处理测试

### 10.1 常见错误码

| 错误码 | 说明 | 处理方式 |
|-------|------|---------|
| 400 | 请求参数错误 | 检查请求参数格式 |
| 401 | 未授权/Token过期 | 重新登录获取新Token |
| 403 | 禁止访问 | 检查用户权限 |
| 404 | 资源不存在 | 检查资源ID是否正确 |
| 500 | 服务器错误 | 联系管理员 |

### 10.2 错误响应格式

```json
{
  "code": 401,
  "message": "未授权",
  "data": null
}
```

---

## 十一、性能测试建议

### 11.1 响应时间要求

| 接口类型 | 响应时间要求 |
|---------|-------------|
| 简单查询接口 | < 100ms |
| 列表查询接口 | < 200ms |
| 复杂查询接口 | < 500ms |
| 写入接口 | < 200ms |

### 11.2 并发测试

建议使用 JMeter 或 Apache Bench 进行并发测试：
```bash
# 使用 ab 进行简单并发测试
ab -n 1000 -c 100 http://localhost:8080/api/videos
```
