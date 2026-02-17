package com.anime.website.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserDTO {
    private Long id;
    private String username;
    private String email;
    private String avatar;
    private String bio;
    private LocalDateTime createdAt;
    private Integer likeCount;
    private Integer commentCount;
    private Integer animeCount;
    private Integer historyCount;
}
