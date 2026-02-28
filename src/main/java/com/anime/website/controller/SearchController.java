package com.anime.website.controller;

import com.anime.website.dto.*;
import com.anime.website.entity.User;
import com.anime.website.security.CurrentUser;
import com.anime.website.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/search")
@RequiredArgsConstructor
@Tag(name = "搜索", description = "搜索相关接口")
public class SearchController {
    
    private final VideoService videoService;
    
    @GetMapping
    @Operation(summary = "搜索视频")
    public ResponseEntity<ApiResponse<PageResponse<VideoDTO>>> searchVideos(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer pageSize) {
        PageResponse<VideoDTO> response = videoService.searchVideos(keyword, page, pageSize);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
