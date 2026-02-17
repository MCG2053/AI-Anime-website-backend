package com.anime.website.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class VideoDTO {
    private Long id;
    private String title;
    private String cover;
    private String description;
    private Integer playCount;
    private Integer likeCount;
    private Integer collectCount;
    private String episode;
    private String category;
    private String country;
    private Integer year;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
