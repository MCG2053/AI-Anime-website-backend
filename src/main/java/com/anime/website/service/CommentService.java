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
public class CommentService {
    
    private final CommentRepository commentRepository;
    private final CommentLikeRepository commentLikeRepository;
    private final UserRepository userRepository;
    private final VideoRepository videoRepository;
    
    public PageResponse<CommentDTO> getComments(Long videoId, Integer page, Integer pageSize, User currentUser) {
        Pageable pageable = PageRequest.of(page - 1, pageSize, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<Comment> commentPage = commentRepository.findByVideoIdAndParentIdIsNull(videoId, pageable);
        
        List<CommentDTO> commentDTOs = commentPage.getContent()
                .stream()
                .map(c -> convertToDTO(c, currentUser))
                .collect(Collectors.toList());
        
        return PageResponse.of(commentDTOs, commentPage.getTotalElements(), page, pageSize);
    }
    
    @Transactional
    public CommentDTO createComment(CreateCommentRequest request, User user) {
        videoRepository.findById(request.getVideoId())
                .orElseThrow(() -> new RuntimeException("视频不存在"));
        
        Comment comment = new Comment();
        comment.setUserId(user.getId());
        comment.setVideoId(request.getVideoId());
        comment.setContent(request.getContent());
        comment.setParentId(request.getParentId());
        
        comment = commentRepository.save(comment);
        
        return convertToDTO(comment, user);
    }
    
    @Transactional
    public void likeComment(Long commentId, User user) {
        if (commentLikeRepository.existsByUserIdAndCommentId(user.getId(), commentId)) {
            throw new RuntimeException("已经点赞过了");
        }
        
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));
        
        CommentLike like = new CommentLike();
        like.setUserId(user.getId());
        like.setCommentId(commentId);
        commentLikeRepository.save(like);
        
        comment.setLikeCount(comment.getLikeCount() + 1);
        commentRepository.save(comment);
    }
    
    @Transactional
    public void unlikeComment(Long commentId, User user) {
        CommentLike like = commentLikeRepository.findByUserIdAndCommentId(user.getId(), commentId)
                .orElseThrow(() -> new RuntimeException("未点赞"));
        
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));
        
        commentLikeRepository.delete(like);
        comment.setLikeCount(Math.max(0, comment.getLikeCount() - 1));
        commentRepository.save(comment);
    }
    
    @Transactional
    public void deleteComment(Long commentId, User user) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));
        
        if (!comment.getUserId().equals(user.getId())) {
            throw new RuntimeException("无权删除此评论");
        }
        
        commentRepository.delete(comment);
    }
    
    public PageResponse<CommentDTO> getUserComments(User user, Integer page, Integer pageSize) {
        Pageable pageable = PageRequest.of(page - 1, pageSize, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<Comment> commentPage = commentRepository.findByUserId(user.getId(), pageable);
        
        List<CommentDTO> commentDTOs = commentPage.getContent()
                .stream()
                .map(c -> convertToDTO(c, user))
                .collect(Collectors.toList());
        
        return PageResponse.of(commentDTOs, commentPage.getTotalElements(), page, pageSize);
    }
    
    private CommentDTO convertToDTO(Comment comment, User currentUser) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setUserId(comment.getUserId());
        dto.setContent(comment.getContent());
        dto.setLikeCount(comment.getLikeCount());
        dto.setCreatedAt(comment.getCreatedAt());
        
        userRepository.findById(comment.getUserId()).ifPresent(user -> {
            dto.setUsername(user.getUsername());
            dto.setAvatar(user.getAvatar());
        });
        
        List<Comment> replies = commentRepository.findByParentId(comment.getId());
        if (!replies.isEmpty()) {
            dto.setReplies(replies.stream()
                    .map(r -> convertToDTO(r, currentUser))
                    .collect(Collectors.toList()));
        }
        
        return dto;
    }
}
