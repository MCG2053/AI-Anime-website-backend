package com.anime.website.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class VideoDetailDTO extends VideoDTO {
    private String videoUrl;
    private List<EpisodeDTO> episodes;
    private List<String> tags;
    private List<VideoDTO> relatedVideos;
}
