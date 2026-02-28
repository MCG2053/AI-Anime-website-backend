package com.anime.website.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "watch_history")
public class WatchHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id")
    private Long userId;
    
    @Column(name = "video_id")
    private Long videoId;
    
    @Column(name = "episode_id")
    private Long episodeId;
    
    @Column(name = "episode_title", length = 100)
    private String episodeTitle;
    
    @Column
    private Integer progress;
    
    @Column(name = "watched_at")
    private LocalDateTime watchedAt;
    
    @PrePersist
    protected void onCreate() {
        watchedAt = LocalDateTime.now();
    }
}
