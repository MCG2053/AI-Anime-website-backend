package com.anime.website.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateCommentRequest {
    @NotNull(message = "视频ID不能为空")
    private Long videoId;
    
    @NotBlank(message = "评论内容不能为空")
    private String content;
    
    private Long parentId;
}
