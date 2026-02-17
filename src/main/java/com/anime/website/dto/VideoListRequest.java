package com.anime.website.dto;

import lombok.Data;

@Data
public class VideoListRequest {
    private String category;
    private Integer year;
    private String type;
    private String country;
    private Integer page = 1;
    private Integer pageSize = 20;
}
