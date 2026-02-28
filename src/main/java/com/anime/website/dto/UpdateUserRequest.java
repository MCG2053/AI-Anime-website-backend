package com.anime.website.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateUserRequest {
    @NotBlank(message = "用户名不能为空")
    private String username;
    private String bio;
}
