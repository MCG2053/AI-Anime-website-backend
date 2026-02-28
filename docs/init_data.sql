-- ============================================
-- 动漫网站数据库初始化脚本
-- 使用方法: mysql -u root -p anime_website < init_data.sql
-- ============================================

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
-- 6. 测试评论
-- ============================================
INSERT INTO comments (user_id, video_id, parent_id, content, like_count, created_at) VALUES
(1, 1, NULL, '神作！进击的巨人结局太震撼了', 128, NOW()),
(1, 3, NULL, '芙莉莲真的太好看了，治愈系神作', 256, NOW()),
(1, 9, NULL, '国漫之光，斗罗大陆yyds', 512, NOW());

-- ============================================
-- 7. 测试弹幕
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
SELECT '数据初始化完成！' AS message;
SELECT COUNT(*) AS video_count FROM videos;
SELECT COUNT(*) AS category_count FROM categories;
SELECT COUNT(*) AS tag_count FROM tags;
