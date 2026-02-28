-- ============================================
-- 动漫网站数据库初始化脚本
-- 使用方法: mysql -u root -p < init_data.sql
-- ============================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS anime_website DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE anime_website;

-- ============================================
-- 删除现有表（按外键依赖顺序，谨慎使用）
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS comment_likes;
DROP TABLE IF EXISTS video_tags;
DROP TABLE IF EXISTS video_collections;
DROP TABLE IF EXISTS video_likes;
DROP TABLE IF EXISTS danmaku;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS watch_history;
DROP TABLE IF EXISTS user_anime;
DROP TABLE IF EXISTS episodes;
DROP TABLE IF EXISTS videos;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 创建表结构
-- ============================================

-- 1. 用户表
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    bio VARCHAR(500),
    created_at DATETIME,
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. 分类表
CREATE TABLE categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE,
    icon VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. 标签表
CREATE TABLE tags (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. 视频表
CREATE TABLE videos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    cover VARCHAR(500),
    description TEXT,
    play_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    collect_count INT DEFAULT 0,
    episode VARCHAR(50),
    category VARCHAR(50),
    country VARCHAR(50),
    year INT,
    video_url VARCHAR(500),
    created_at DATETIME,
    updated_at DATETIME,
    INDEX idx_videos_category (category),
    INDEX idx_videos_year (year),
    INDEX idx_videos_country (country),
    INDEX idx_videos_play_count (play_count),
    INDEX idx_videos_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. 集数表
CREATE TABLE episodes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    video_id BIGINT,
    title VARCHAR(100) NOT NULL,
    video_url VARCHAR(500),
    duration INT,
    episode_number INT,
    created_at DATETIME,
    INDEX idx_episodes_video_id (video_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. 视频标签关联表
CREATE TABLE video_tags (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    video_id BIGINT,
    tag_id BIGINT,
    INDEX idx_video_tags_video_id (video_id),
    INDEX idx_video_tags_tag_id (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. 评论表
CREATE TABLE comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    video_id BIGINT,
    parent_id BIGINT,
    content TEXT,
    like_count INT DEFAULT 0,
    created_at DATETIME,
    INDEX idx_comments_video_id (video_id),
    INDEX idx_comments_user_id (user_id),
    INDEX idx_comments_parent_id (parent_id),
    INDEX idx_comments_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. 评论点赞表
CREATE TABLE comment_likes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    comment_id BIGINT,
    created_at DATETIME,
    INDEX idx_comment_likes_user_id (user_id),
    INDEX idx_comment_likes_comment_id (comment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. 弹幕表
CREATE TABLE danmaku (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    video_id BIGINT,
    episode_id BIGINT,
    user_id BIGINT,
    content TEXT,
    time DOUBLE,
    color VARCHAR(20) DEFAULT '#ffffff',
    type VARCHAR(20) DEFAULT 'scroll',
    created_at DATETIME,
    INDEX idx_danmaku_video_episode (video_id, episode_id),
    INDEX idx_danmaku_video_id (video_id),
    INDEX idx_danmaku_time (time),
    INDEX idx_danmaku_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. 视频点赞表
CREATE TABLE video_likes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    video_id BIGINT,
    created_at DATETIME,
    INDEX idx_video_likes_user_id (user_id),
    INDEX idx_video_likes_video_id (video_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. 视频收藏表
CREATE TABLE video_collections (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    video_id BIGINT,
    created_at DATETIME,
    INDEX idx_video_collections_user_id (user_id),
    INDEX idx_video_collections_video_id (video_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. 观看历史表
CREATE TABLE watch_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    video_id BIGINT,
    episode_id BIGINT,
    episode_title VARCHAR(100),
    progress INT,
    watched_at DATETIME,
    INDEX idx_watch_history_user_id (user_id),
    INDEX idx_watch_history_video_id (video_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. 用户追番表
CREATE TABLE user_anime (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    video_id BIGINT,
    status VARCHAR(20),
    added_at DATETIME,
    INDEX idx_user_anime_user_id (user_id),
    INDEX idx_user_anime_video_id (video_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 插入初始数据
-- ============================================

-- ============================================
-- 1. 分类数据
-- ============================================
INSERT INTO categories (name, slug, icon) VALUES
('番剧', 'bangumi', '📺'),
('国创', 'guochuang', '🎬'),
('电影', 'movie', '🎥'),
('欧美', 'western', '🌍'),
('综艺', 'variety', '🎭');

-- ============================================
-- 2. 标签数据
-- ============================================
INSERT INTO tags (name, type) VALUES
-- 类型标签
('热血', 'genre'),
('恋爱', 'genre'),
('校园', 'genre'),
('奇幻', 'genre'),
('搞笑', 'genre'),
('冒险', 'genre'),
('科幻', 'genre'),
('悬疑', 'genre'),
('治愈', 'genre'),
('运动', 'genre'),
-- 地区标签
('日本', 'country'),
('中国', 'country'),
('美国', 'country'),
('韩国', 'country');

-- ============================================
-- 3. 视频数据
-- ============================================
INSERT INTO videos (title, cover, description, play_count, like_count, collect_count, episode, category, country, year, video_url, created_at, updated_at) VALUES
-- 番剧
('进击的巨人 最终季 Part3', 
 'https://picsum.photos/seed/aot/300/400', 
 '艾伦·耶格尔为了自由，发动了地鸣。数以万计的超大型巨人向大陆进发，世界即将迎来终结。在绝望与希望之间，调查兵团的幸存者们必须做出最后的选择...', 
 2500000, 120000, 85000, '全2集(后篇)', '番剧', '日本', 2024, 
 'https://example.com/videos/aot.mp4', NOW(), NOW()),

('鬼灭之刃 柱训练篇', 
 'https://picsum.photos/seed/kimetsu/300/400', 
 '鬼杀队最强的剑士"柱"们，为了打倒鬼舞辻无惨，开始了最后的特训。炭治郎等人也在柱的指导下不断成长，为最终决战做准备...', 
 1800000, 95000, 68000, '全8集', '番剧', '日本', 2024, 
 'https://example.com/videos/kimetsu.mp4', NOW(), NOW()),

('葬送的芙莉莲', 
 'https://picsum.photos/seed/frieren/300/400', 
 '勇者一行打倒魔王后，精灵魔法使芙莉莲开始了寻找魔法之旅。在漫长的旅途中，她逐渐理解了人类的情感与生命的珍贵...', 
 3200000, 180000, 120000, '全28集', '番剧', '日本', 2023, 
 'https://example.com/videos/frieren.mp4', NOW(), NOW()),

('间谍过家家 第二季', 
 'https://picsum.photos/seed/spyxfamily/300/400', 
 '黄昏、约尔、阿尼亚，这个临时组成的家庭继续着他们的秘密生活。阿尼亚在学校闹出各种笑话，而黄昏的任务也在继续...', 
 2100000, 110000, 78000, '更新至第12集', '番剧', '日本', 2024, 
 'https://example.com/videos/spyxfamily.mp4', NOW(), NOW()),

('咒术回战 第二季', 
 'https://picsum.photos/seed/jjk/300/400', 
 '怀玉篇与玉折篇。五条悟的过去，夏油杰的堕落。涉谷事变的前奏，诅咒师们的阴谋逐渐浮出水面...', 
 2800000, 150000, 98000, '全23集', '番剧', '日本', 2023, 
 'https://example.com/videos/jjk.mp4', NOW(), NOW()),

('我推的孩子', 
 'https://picsum.photos/seed/oshinoko/300/400', 
 '妇产科医生五郎转生成为偶像星野爱的孩子。在演艺圈的光鲜背后，隐藏着不为人知的秘密与阴谋...', 
 1900000, 100000, 72000, '全11集', '番剧', '日本', 2023, 
 'https://example.com/videos/oshinoko.mp4', NOW(), NOW()),

('药屋少女的呢喃', 
 'https://picsum.photos/seed/kusuriya/300/400', 
 '猫猫，一个在花街长大的药师少女，被卖入后宫。凭借她的药学知识和推理能力，在后宫中解决各种谜团...', 
 1600000, 85000, 58000, '更新至第24集', '番剧', '日本', 2024, 
 'https://example.com/videos/kusuriya.mp4', NOW(), NOW()),

('无职转生 第二季', 
 'https://picsum.photos/seed/mushoku/300/400', 
 '鲁迪乌斯在异世界的冒险继续。新的旅程，新的邂逅，他逐渐成长为一个真正的冒险者...', 
 1500000, 80000, 55000, '更新至第12集', '番剧', '日本', 2024, 
 'https://example.com/videos/mushoku.mp4', NOW(), NOW()),

-- 国创
('斗罗大陆 第二季', 
 'https://picsum.photos/seed/douluo/300/400', 
 '唐三与史莱克七怪的冒险继续。在斗罗大陆上，他们面对更强大的敌人，书写属于自己的传奇...', 
 4500000, 220000, 150000, '更新至第200集', '国创', '中国', 2024, 
 'https://example.com/videos/douluo.mp4', NOW(), NOW()),

('完美世界', 
 'https://picsum.photos/seed/perfectworld/300/400', 
 '一粒尘可填海，一根草斩日月。石昊从大荒中走出，踏上成为强者的道路，面对诸神的挑战...', 
 3800000, 190000, 130000, '更新至第150集', '国创', '中国', 2024, 
 'https://example.com/videos/perfectworld.mp4', NOW(), NOW()),

('凡人修仙传', 
 'https://picsum.photos/seed/fanren/300/400', 
 '韩立，一个普通的山村穷小子，偶然之下跨入江湖小门派，开始了他的修仙之路...', 
 3200000, 160000, 110000, '更新至第180集', '国创', '中国', 2024, 
 'https://example.com/videos/fanren.mp4', NOW(), NOW()),

('一念永恒', 
 'https://picsum.photos/seed/yinian/300/400', 
 '白小纯，一个怕死的少年，为了长生而踏入修仙界。搞笑与热血并存，开启不一样的修仙之旅...', 
 2100000, 105000, 72000, '全52集', '国创', '中国', 2023, 
 'https://example.com/videos/yinian.mp4', NOW(), NOW()),

('吞噬星空', 
 'https://picsum.photos/seed/tunshi/300/400', 
 '地球遭遇RR病毒，人类文明岌岌可危。罗峰从一个普通学生，成长为守护地球的强者...', 
 2600000, 130000, 88000, '更新至第100集', '国创', '中国', 2024, 
 'https://example.com/videos/tunshi.mp4', NOW(), NOW()),

('仙逆', 
 'https://picsum.photos/seed/xianni/300/400', 
 '王林，一个资质平庸的少年，凭借坚韧的意志和逆天的机缘，踏上修仙之路，最终成为一代强者...', 
 1800000, 90000, 62000, '更新至第24集', '国创', '中国', 2024, 
 'https://example.com/videos/xianni.mp4', NOW(), NOW()),

-- 电影
('铃芽之旅', 
 'https://picsum.photos/seed/suzume/300/400', 
 '新海诚最新力作。少女铃芽遇到了寻找"门"的青年，踏上了一段奇妙的旅程，面对过去的伤痛，寻找希望...', 
 5000000, 280000, 200000, '剧场版', '电影', '日本', 2023, 
 'https://example.com/videos/suzume.mp4', NOW(), NOW()),

('你想活出怎样的人生', 
 'https://picsum.photos/seed/kimitachi/300/400', 
 '宫崎骏最新作品。少年牧真人因母亲去世而陷入悲伤，一只会说话的苍鹭引领他进入了一个奇幻的世界...', 
 4200000, 230000, 165000, '剧场版', '电影', '日本', 2023, 
 'https://example.com/videos/kimitachi.mp4', NOW(), NOW()),

('长安三万里', 
 'https://picsum.photos/seed/changan/300/400', 
 '盛唐时期，李白与高适的友情故事。诗人们的豪情壮志，大唐的繁华与衰落，一幅壮丽的历史画卷...', 
 3800000, 210000, 145000, '剧场版', '电影', '中国', 2023, 
 'https://example.com/videos/changan.mp4', NOW(), NOW()),

('深海', 
 'https://picsum.photos/seed/shenhai/300/400', 
 '少女参宿意外坠入深海，遇到了神秘的南河。在绚丽的深海世界中，她寻找着内心的救赎...', 
 2500000, 140000, 95000, '剧场版', '电影', '中国', 2023, 
 'https://example.com/videos/shenhai.mp4', NOW(), NOW());

-- ============================================
-- 4. 视频标签关联
-- ============================================
INSERT INTO video_tags (video_id, tag_id) VALUES
-- 进击的巨人
(1, 1), (1, 4), (1, 8), (1, 11),
-- 鬼灭之刃
(2, 1), (2, 4), (2, 11),
-- 葬送的芙莉莲
(3, 4), (3, 9), (3, 11),
-- 间谍过家家
(4, 5), (4, 3), (4, 11),
-- 咒术回战
(5, 1), (5, 4), (5, 11),
-- 我推的孩子
(6, 8), (6, 11),
-- 药屋少女
(7, 8), (7, 11),
-- 无职转生
(8, 4), (8, 6), (8, 11),
-- 斗罗大陆
(9, 1), (9, 4), (9, 12),
-- 完美世界
(10, 1), (10, 4), (10, 12),
-- 凡人修仙传
(11, 1), (11, 4), (11, 12),
-- 一念永恒
(12, 1), (12, 5), (12, 4), (12, 12),
-- 吞噬星空
(13, 1), (13, 7), (13, 12),
-- 仙逆
(14, 1), (14, 4), (14, 12),
-- 铃芽之旅
(15, 4), (15, 6), (15, 11),
-- 你想活出怎样的人生
(16, 4), (16, 9), (16, 11),
-- 长安三万里
(17, 4), (17, 12),
-- 深海
(18, 4), (18, 9), (18, 12);

-- ============================================
-- 5. 视频集数
-- ============================================
INSERT INTO episodes (video_id, title, video_url, duration, episode_number, created_at) VALUES
-- 进击的巨人
(1, '后篇 前编', 'https://example.com/videos/aot-ep1.mp4', 3600, 1, NOW()),
(1, '后篇 后编', 'https://example.com/videos/aot-ep2.mp4', 4800, 2, NOW()),

-- 鬼灭之刃 柱训练篇
(2, '第1集 柱合会议', 'https://example.com/videos/kimetsu-ep1.mp4', 1440, 1, NOW()),
(2, '第2集 水柱的训练', 'https://example.com/videos/kimetsu-ep2.mp4', 1440, 2, NOW()),
(2, '第3集 虫柱的药', 'https://example.com/videos/kimetsu-ep3.mp4', 1440, 3, NOW()),
(2, '第4集 恋柱的温泉', 'https://example.com/videos/kimetsu-ep4.mp4', 1440, 4, NOW()),
(2, '第5集 风柱的磨炼', 'https://example.com/videos/kimetsu-ep5.mp4', 1440, 5, NOW()),
(2, '第6集 音柱的指导', 'https://example.com/videos/kimetsu-ep6.mp4', 1440, 6, NOW()),
(2, '第7集 霞柱的教导', 'https://example.com/videos/kimetsu-ep7.mp4', 1440, 7, NOW()),
(2, '第8集 最终训练', 'https://example.com/videos/kimetsu-ep8.mp4', 1440, 8, NOW()),

-- 葬送的芙莉莲
(3, '第1集 旅程的终点', 'https://example.com/videos/frieren-ep1.mp4', 1440, 1, NOW()),
(3, '第2集 不该去的旅程', 'https://example.com/videos/frieren-ep2.mp4', 1440, 2, NOW()),
(3, '第3集 杀人魔法', 'https://example.com/videos/frieren-ep3.mp4', 1440, 3, NOW()),
(3, '第4集 灵魂的安息地', 'https://example.com/videos/frieren-ep4.mp4', 1440, 4, NOW()),
(3, '第5集 死者的幻影', 'https://example.com/videos/frieren-ep5.mp4', 1440, 5, NOW()),

-- 斗罗大陆
(9, '第1集 史莱克学院', 'https://example.com/videos/douluo-ep1.mp4', 1440, 1, NOW()),
(9, '第2集 七怪聚首', 'https://example.com/videos/douluo-ep2.mp4', 1440, 2, NOW()),
(9, '第3集 魂环觉醒', 'https://example.com/videos/douluo-ep3.mp4', 1440, 3, NOW()),
(9, '第4集 星斗大森林', 'https://example.com/videos/douluo-ep4.mp4', 1440, 4, NOW()),
(9, '第5集 泰坦巨猿', 'https://example.com/videos/douluo-ep5.mp4', 1440, 5, NOW()),

-- 完美世界
(10, '第1集 石村', 'https://example.com/videos/perfectworld-ep1.mp4', 1440, 1, NOW()),
(10, '第2集 狻猊宝术', 'https://example.com/videos/perfectworld-ep2.mp4', 1440, 2, NOW()),
(10, '第3集 大荒之行', 'https://example.com/videos/perfectworld-ep3.mp4', 1440, 3, NOW()),
(10, '第4集 补天阁', 'https://example.com/videos/perfectworld-ep4.mp4', 1440, 4, NOW()),
(10, '第5集 上古遗种', 'https://example.com/videos/perfectworld-ep5.mp4', 1440, 5, NOW());

-- ============================================
-- 6. 测试用户（密码为 123456 的BCrypt加密）
-- ============================================
INSERT INTO users (username, email, password, avatar, bio, created_at, updated_at) VALUES
('admin', 'admin@anime.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', 'https://picsum.photos/seed/admin/200/200', '管理员账号', NOW(), NOW()),
('testuser', 'test@anime.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', 'https://picsum.photos/seed/test/200/200', '测试用户', NOW(), NOW());

-- ============================================
-- 7. 测试评论
-- ============================================
INSERT INTO comments (user_id, video_id, parent_id, content, like_count, created_at) VALUES
(1, 1, NULL, '神作！进击的巨人结局太震撼了', 128, NOW()),
(1, 3, NULL, '芙莉莲真的太好看了，治愈系神作', 256, NOW()),
(1, 9, NULL, '国漫之光，斗罗大陆yyds', 512, NOW());

-- ============================================
-- 8. 测试弹幕
-- ============================================
INSERT INTO danmaku (video_id, episode_id, user_id, content, time, color, type, created_at) VALUES
(1, 1, 1, '前方高能预警', 120.5, '#ff0000', 'scroll', NOW()),
(1, 1, 1, '太燃了', 180.3, '#ffffff', 'scroll', NOW()),
(1, 1, 1, '艾伦！！', 240.8, '#ffff00', 'top', NOW()),
(3, 1, 1, '芙莉莲好可爱', 60.2, '#ff69b4', 'scroll', NOW()),
(3, 1, 1, '这画面太美了', 300.5, '#ffffff', 'scroll', NOW());

-- ============================================
-- 完成提示
-- ============================================
SELECT '数据库初始化完成！' AS message;
SELECT COUNT(*) AS video_count FROM videos;
SELECT COUNT(*) AS category_count FROM categories;
SELECT COUNT(*) AS tag_count FROM tags;
SELECT COUNT(*) AS user_count FROM users;
