package com.anime.website.dto;

import lombok.Data;
import java.util.List;

@Data
public class UserAnimeListDTO {
    private List<UserAnimeDTO> watching;
    private List<UserAnimeDTO> completed;
    private List<WatchHistoryDTO> history;
}
