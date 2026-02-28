package com.anime.website.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DanmakuReportRequest {
    @NotBlank(message = "举报原因不能为空")
    private String reason;
}
