package com.anime.website.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AddAnimeRequest {
    @NotNull(message = "视频ID不能为空")
    private Long videoId;
    
    @NotNull(message = "状态不能为空")
    private String status;
}
