package com.anime.website.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class DanmakuDTO {
    private Long id;
    private String content;
    private Double time;
    private String color;
    private String type;
    private Long userId;
    private LocalDateTime createdAt;
}
