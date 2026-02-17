package com.anime.website.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class WatchHistoryDTO {
    private Long videoId;
    private Long episodeId;
    private String episodeTitle;
    private LocalDateTime watchedAt;
    private Integer progress;
    private VideoDTO video;
}
