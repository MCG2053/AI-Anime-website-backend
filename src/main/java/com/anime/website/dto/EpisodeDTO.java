package com.anime.website.dto;

import lombok.Data;

@Data
public class EpisodeDTO {
    private Long id;
    private String title;
    private String videoUrl;
    private Integer duration;
}
