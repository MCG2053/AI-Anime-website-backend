package com.anime.website.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateDanmakuRequest {
    @NotNull(message = "视频ID不能为空")
    private Long videoId;
    
    private Long episodeId;
    
    @NotBlank(message = "弹幕内容不能为空")
    private String content;
    
    @NotNull(message = "时间不能为空")
    private Double time;
    
    private String color = "#ffffff";
    private String type = "scroll";
}
