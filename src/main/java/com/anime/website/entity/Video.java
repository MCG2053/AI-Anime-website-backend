package com.anime.website.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "videos")
public class Video {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 200)
    private String title;
    
    @Column(length = 500)
    private String cover;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "play_count")
    private Integer playCount = 0;
    
    @Column(name = "like_count")
    private Integer likeCount = 0;
    
    @Column(name = "collect_count")
    private Integer collectCount = 0;
    
    @Column(length = 50)
    private String episode;
    
    @Column(length = 50)
    private String category;
    
    @Column(length = 50)
    private String country;
    
    @Column
    private Integer year;
    
    @Column(name = "video_url", length = 500)
    private String videoUrl;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (playCount == null) playCount = 0;
        if (likeCount == null) likeCount = 0;
        if (collectCount == null) collectCount = 0;
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
