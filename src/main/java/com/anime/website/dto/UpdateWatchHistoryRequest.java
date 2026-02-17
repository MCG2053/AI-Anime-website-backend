package com.anime.website.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateWatchHistoryRequest {
    @NotNull(message = "视频ID不能为空")
    private Long videoId;
    
    private Long episodeId;
    
    private String episodeTitle;
    
    private Integer progress;
}
