package com.anime.website.dto;

import lombok.Data;
import java.util.List;

@Data
public class UserLikesDTO {
    private List<Long> videoIds;
    private List<Long> commentIds;
}
