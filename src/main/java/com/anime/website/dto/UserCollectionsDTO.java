package com.anime.website.dto;

import lombok.Data;
import java.util.List;

@Data
public class UserCollectionsDTO {
    private List<Long> videoIds;
}
