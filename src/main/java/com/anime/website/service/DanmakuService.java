package com.anime.website.service;

import com.anime.website.dto.*;
import com.anime.website.entity.*;
import com.anime.website.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DanmakuService {
    
    private final DanmakuRepository danmakuRepository;
    
    public List<DanmakuDTO> getDanmaku(Long videoId, Long episodeId) {
        List<Danmaku> danmakuList;
        
        if (episodeId != null) {
            danmakuList = danmakuRepository.findByVideoIdAndEpisodeIdOrderByTimeAsc(videoId, episodeId);
        } else {
            danmakuList = danmakuRepository.findByVideoIdOrderByTimeAsc(videoId);
        }
        
        return danmakuList.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public DanmakuDTO createDanmaku(CreateDanmakuRequest request, User user) {
        Danmaku danmaku = new Danmaku();
        danmaku.setVideoId(request.getVideoId());
        danmaku.setEpisodeId(request.getEpisodeId());
        danmaku.setUserId(user.getId());
        danmaku.setContent(request.getContent());
        danmaku.setTime(request.getTime());
        danmaku.setColor(request.getColor() != null ? request.getColor() : "#ffffff");
        danmaku.setType(request.getType() != null ? request.getType() : "scroll");
        
        danmaku = danmakuRepository.save(danmaku);
        
        return convertToDTO(danmaku);
    }
    
    private DanmakuDTO convertToDTO(Danmaku danmaku) {
        DanmakuDTO dto = new DanmakuDTO();
        dto.setId(danmaku.getId());
        dto.setContent(danmaku.getContent());
        dto.setTime(danmaku.getTime());
        dto.setColor(danmaku.getColor());
        dto.setType(danmaku.getType());
        dto.setUserId(danmaku.getUserId());
        dto.setCreatedAt(danmaku.getCreatedAt());
        return dto;
    }
}
