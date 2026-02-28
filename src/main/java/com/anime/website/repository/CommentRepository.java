package com.anime.website.repository;

import com.anime.website.entity.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    Page<Comment> findByVideoIdAndParentIdIsNull(Long videoId, Pageable pageable);
    List<Comment> findByParentId(Long parentId);
    
    @Query("SELECT c FROM Comment c WHERE c.userId = :userId ORDER BY c.createdAt DESC")
    Page<Comment> findByUserId(@Param("userId") Long userId, Pageable pageable);
    
    @Query("SELECT COUNT(c) FROM Comment c WHERE c.userId = :userId")
    Long countByUserId(@Param("userId") Long userId);
}
