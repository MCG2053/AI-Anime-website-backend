package com.anime.website.repository;

import com.anime.website.entity.Episode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EpisodeRepository extends JpaRepository<Episode, Long> {
    List<Episode> findByVideoIdOrderByEpisodeNumberAsc(Long videoId);
}
