package com.heoby.detection.repository;

import com.heoby.global.common.entity.Detection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface DetectionRepository extends JpaRepository<Detection, Long> {

  @Query("""
        SELECT d
        FROM Detection d
        WHERE d.scarecrow.crowUuid = :crowUuid
          AND d.createdAt >= :since
        ORDER BY d.createdAt DESC
        """)
  List<Detection> findByCrowUuid(
      @Param("crowUuid") String crowUuid,
      @Param("since") LocalDateTime since
  );

  List<Detection> findByDetectionIdIn(List<Long> detectionIds);
}
