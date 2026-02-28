package com.anime.website.service;

import com.anime.website.dto.*;
import com.anime.website.entity.*;
import com.anime.website.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserAnimeService {
    
    private final UserAnimeRepository userAnimeRepository;
    private final WatchHistoryRepository watchHistoryRepository;
    private final VideoRepository videoRepository;
    private final VideoService videoService;
    
    public UserAnimeListDTO getAnimeList(User user) {
        UserAnimeListDTO listDTO = new UserAnimeListDTO();
        
        List<UserAnime> watchingList = userAnimeRepository.findByUserIdAndStatus(user.getId(), "watching");
        List<UserAnime> completedList = userAnimeRepository.findByUserIdAndStatus(user.getId(), "completed");
        
        listDTO.setWatching(watchingList.stream()
                .map(ua -> convertToDTO(ua))
                .collect(Collectors.toList()));
        
        listDTO.setCompleted(completedList.stream()
                .map(ua -> convertToDTO(ua))
                .collect(Collectors.toList()));
        
        Page<WatchHistory> historyPage = watchHistoryRepository.findByUserIdOrderByWatchedAtDesc(
            user.getId(), 
            PageRequest.of(0, 20)
        );
        
        listDTO.setHistory(historyPage.getContent().stream()
                .map(this::convertHistoryToDTO)
                .collect(Collectors.toList()));
        
        return listDTO;
    }
    
    @Transactional
    public void addAnime(AddAnimeRequest request, User user) {
        if (userAnimeRepository.findByUserIdAndVideoId(user.getId(), request.getVideoId()).isPresent()) {
            throw new RuntimeException("已经添加到追番列表");
        }
        
        videoRepository.findById(request.getVideoId())
                .orElseThrow(() -> new RuntimeException("视频不存在"));
        
        UserAnime userAnime = new UserAnime();
        userAnime.setUserId(user.getId());
        userAnime.setVideoId(request.getVideoId());
        userAnime.setStatus(request.getStatus());
        
        userAnimeRepository.save(userAnime);
    }
    
    @Transactional
    public void removeAnime(Long videoId, User user) {
        userAnimeRepository.deleteByUserIdAndVideoId(user.getId(), videoId);
    }
    
    @Transactional
    public void updateAnimeStatus(Long videoId, UpdateAnimeStatusRequest request, User user) {
        UserAnime userAnime = userAnimeRepository.findByUserIdAndVideoId(user.getId(), videoId)
                .orElseThrow(() -> new RuntimeException("未找到追番记录"));
        
        userAnime.setStatus(request.getStatus());
        userAnimeRepository.save(userAnime);
    }
    
    public PageResponse<WatchHistoryDTO> getWatchHistory(User user, Integer page, Integer pageSize) {
        Pageable pageable = PageRequest.of(page - 1, pageSize, Sort.by(Sort.Direction.DESC, "watchedAt"));
        Page<WatchHistory> historyPage = watchHistoryRepository.findByUserIdOrderByWatchedAtDesc(user.getId(), pageable);
        
        List<WatchHistoryDTO> historyDTOs = historyPage.getContent()
                .stream()
                .map(this::convertHistoryToDTO)
                .collect(Collectors.toList());
        
        return PageResponse.of(historyDTOs, historyPage.getTotalElements(), page, pageSize);
    }
    
    @Transactional
    public void updateWatchHistory(UpdateWatchHistoryRequest request, User user) {
        videoRepository.findById(request.getVideoId())
                .orElseThrow(() -> new RuntimeException("视频不存在"));
        
        WatchHistory history = watchHistoryRepository.findByUserIdAndVideoId(user.getId(), request.getVideoId())
                .orElse(new WatchHistory());
        
        history.setUserId(user.getId());
        history.setVideoId(request.getVideoId());
        history.setEpisodeId(request.getEpisodeId());
        history.setEpisodeTitle(request.getEpisodeTitle());
        history.setProgress(request.getProgress());
        
        watchHistoryRepository.save(history);
    }
    
    @Transactional
    public void removeWatchHistory(Long videoId, User user) {
        watchHistoryRepository.deleteByUserIdAndVideoId(user.getId(), videoId);
    }
    
    @Transactional
    public void clearWatchHistory(User user) {
        watchHistoryRepository.deleteByUserId(user.getId());
    }
    
    private UserAnimeDTO convertToDTO(UserAnime userAnime) {
        UserAnimeDTO dto = new UserAnimeDTO();
        dto.setVideoId(userAnime.getVideoId());
        dto.setStatus(userAnime.getStatus());
        dto.setAddedAt(userAnime.getAddedAt());
        
        videoRepository.findById(userAnime.getVideoId()).ifPresent(video -> {
            VideoDTO videoDTO = new VideoDTO();
            videoDTO.setId(video.getId());
            videoDTO.setTitle(video.getTitle());
            videoDTO.setCover(video.getCover());
            videoDTO.setDescription(video.getDescription());
            videoDTO.setPlayCount(video.getPlayCount());
            videoDTO.setLikeCount(video.getLikeCount());
            videoDTO.setCollectCount(video.getCollectCount());
            videoDTO.setEpisode(video.getEpisode());
            videoDTO.setCategory(video.getCategory());
            videoDTO.setCountry(video.getCountry());
            videoDTO.setYear(video.getYear());
            videoDTO.setCreatedAt(video.getCreatedAt());
            videoDTO.setUpdatedAt(video.getUpdatedAt());
            dto.setVideo(videoDTO);
        });
        
        return dto;
    }
    
    private WatchHistoryDTO convertHistoryToDTO(WatchHistory history) {
        WatchHistoryDTO dto = new WatchHistoryDTO();
        dto.setVideoId(history.getVideoId());
        dto.setEpisodeId(history.getEpisodeId());
        dto.setEpisodeTitle(history.getEpisodeTitle());
        dto.setWatchedAt(history.getWatchedAt());
        dto.setProgress(history.getProgress());
        
        videoRepository.findById(history.getVideoId()).ifPresent(video -> {
            VideoDTO videoDTO = new VideoDTO();
            videoDTO.setId(video.getId());
            videoDTO.setTitle(video.getTitle());
            videoDTO.setCover(video.getCover());
            videoDTO.setDescription(video.getDescription());
            videoDTO.setPlayCount(video.getPlayCount());
            videoDTO.setLikeCount(video.getLikeCount());
            videoDTO.setCollectCount(video.getCollectCount());
            videoDTO.setEpisode(video.getEpisode());
            videoDTO.setCategory(video.getCategory());
            videoDTO.setCountry(video.getCountry());
            videoDTO.setYear(video.getYear());
            videoDTO.setCreatedAt(video.getCreatedAt());
            videoDTO.setUpdatedAt(video.getUpdatedAt());
            dto.setVideo(videoDTO);
        });
        
        return dto;
    }
}
