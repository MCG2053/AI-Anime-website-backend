package com.anime.website.repository;

import com.anime.website.entity.VideoCollection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface VideoCollectionRepository extends JpaRepository<VideoCollection, Long> {
    Optional<VideoCollection> findByUserIdAndVideoId(Long userId, Long videoId);
    List<VideoCollection> findByUserId(Long userId);
    void deleteByUserIdAndVideoId(Long userId, Long videoId);
    boolean existsByUserIdAndVideoId(Long userId, Long videoId);
}
