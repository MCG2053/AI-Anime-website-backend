package com.anime.website.dto;

import lombok.Data;

@Data
public class DanmakuStatsDTO {
    private Long total;
    private Long scrollCount;
    private Long topCount;
    private Long bottomCount;
}
