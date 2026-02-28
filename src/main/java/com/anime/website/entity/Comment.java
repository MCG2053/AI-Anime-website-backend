package com.anime.website.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "comments", indexes = {
    @Index(name = "idx_comments_video_id", columnList = "video_id"),
    @Index(name = "idx_comments_user_id", columnList = "user_id"),
    @Index(name = "idx_comments_parent_id", columnList = "parent_id"),
    @Index(name = "idx_comments_created_at", columnList = "created_at")
})
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id")
    private Long userId;
    
    @Column(name = "video_id")
    private Long videoId;
    
    @Column(name = "parent_id")
    private Long parentId;
    
    @Column(columnDefinition = "TEXT")
    private String content;
    
    @Column(name = "like_count")
    private Integer likeCount = 0;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (likeCount == null) likeCount = 0;
    }
}
