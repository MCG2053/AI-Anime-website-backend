package com.anime.website.controller;

import com.anime.website.dto.*;
import com.anime.website.entity.User;
import com.anime.website.security.CurrentUser;
import com.anime.website.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "弹幕管理", description = "弹幕相关接口")
public class DanmakuController {
    
    private final DanmakuService danmakuService;
    
    @GetMapping("/videos/{videoId}/danmaku")
    @Operation(summary = "获取弹幕列表")
    public ResponseEntity<ApiResponse<List<DanmakuDTO>>> getDanmaku(
            @PathVariable Long videoId,
            @RequestParam(required = false) Long episodeId) {
        List<DanmakuDTO> response = danmakuService.getDanmaku(videoId, episodeId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @PostMapping("/danmaku")
    @Operation(summary = "发送弹幕")
    public ResponseEntity<ApiResponse<DanmakuDTO>> createDanmaku(
            @Valid @RequestBody CreateDanmakuRequest request,
            @CurrentUser User user) {
        DanmakuDTO response = danmakuService.createDanmaku(request, user);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
