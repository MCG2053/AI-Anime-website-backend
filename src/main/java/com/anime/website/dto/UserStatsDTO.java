package com.anime.website.dto;

import lombok.Data;

@Data
public class UserStatsDTO {
    private Integer likeCount;
    private Integer commentCount;
    private Integer animeCount;
    private Integer historyCount;
    private Long watchTime;
}
