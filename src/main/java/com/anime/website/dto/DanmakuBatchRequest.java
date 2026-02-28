package com.anime.website.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class DanmakuBatchRequest {
    @NotNull(message = "视频ID不能为空")
    private Long videoId;
    
    @NotEmpty(message = "集数ID列表不能为空")
    private List<Long> episodeIds;
}
