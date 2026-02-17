package com.anime.website.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserAnimeDTO {
    private Long videoId;
    private String status;
    private LocalDateTime addedAt;
    private VideoDTO video;
}
