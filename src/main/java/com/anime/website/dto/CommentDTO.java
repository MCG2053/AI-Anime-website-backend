package com.anime.website.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CommentDTO {
    private Long id;
    private Long userId;
    private String username;
    private String avatar;
    private String content;
    private Integer likeCount;
    private LocalDateTime createdAt;
    private List<CommentDTO> replies;
}
