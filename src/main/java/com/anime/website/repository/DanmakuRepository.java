package com.anime.website.repository;

import com.anime.website.entity.Danmaku;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DanmakuRepository extends JpaRepository<Danmaku, Long> {
    List<Danmaku> findByVideoIdAndEpisodeIdOrderByTimeAsc(Long videoId, Long episodeId);
    List<Danmaku> findByVideoIdOrderByTimeAsc(Long videoId);
}
