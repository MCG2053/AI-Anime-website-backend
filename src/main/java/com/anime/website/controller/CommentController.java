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

@RestController
@RequiredArgsConstructor
@Tag(name = "评论管理", description = "评论相关接口")
public class CommentController {
    
    private final CommentService commentService;
    
    @GetMapping("/videos/{videoId}/comments")
    @Operation(summary = "获取视频评论")
    public ResponseEntity<ApiResponse<PageResponse<CommentDTO>>> getComments(
            @PathVariable Long videoId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer pageSize,
            @CurrentUser User user) {
        PageResponse<CommentDTO> response = commentService.getComments(videoId, page, pageSize, user);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @PostMapping("/comments")
    @Operation(summary = "发表评论")
    public ResponseEntity<ApiResponse<CommentDTO>> createComment(
            @Valid @RequestBody CreateCommentRequest request,
            @CurrentUser User user) {
        CommentDTO response = commentService.createComment(request, user);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @PostMapping("/comments/{id}/like")
    @Operation(summary = "点赞评论")
    public ResponseEntity<ApiResponse<SuccessResponse>> likeComment(
            @PathVariable Long id,
            @CurrentUser User user) {
        commentService.likeComment(id, user);
        return ResponseEntity.ok(ApiResponse.success(SuccessResponse.of(true)));
    }
    
    @DeleteMapping("/comments/{id}/like")
    @Operation(summary = "取消点赞评论")
    public ResponseEntity<ApiResponse<SuccessResponse>> unlikeComment(
            @PathVariable Long id,
            @CurrentUser User user) {
        commentService.unlikeComment(id, user);
        return ResponseEntity.ok(ApiResponse.success(SuccessResponse.of(true)));
    }
    
    @DeleteMapping("/comments/{id}")
    @Operation(summary = "删除评论")
    public ResponseEntity<ApiResponse<SuccessResponse>> deleteComment(
            @PathVariable Long id,
            @CurrentUser User user) {
        commentService.deleteComment(id, user);
        return ResponseEntity.ok(ApiResponse.success(SuccessResponse.of(true)));
    }
}
