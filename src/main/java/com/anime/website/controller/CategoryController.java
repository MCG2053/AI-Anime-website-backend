package com.anime.website.controller;

import com.anime.website.dto.*;
import com.anime.website.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "分类和标签", description = "分类和标签相关接口")
public class CategoryController {
    
    private final CategoryService categoryService;
    private final TagService tagService;
    
    @GetMapping("/categories")
    @Operation(summary = "获取分类列表")
    public ResponseEntity<ApiResponse<List<CategoryDTO>>> getAllCategories() {
        List<CategoryDTO> response = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @GetMapping("/tags")
    @Operation(summary = "获取标签列表")
    public ResponseEntity<ApiResponse<List<TagDTO>>> getAllTags() {
        List<TagDTO> response = tagService.getAllTags();
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
