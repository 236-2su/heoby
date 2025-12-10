package com.heoby.detection.service;

import com.heoby.ai.dto.AiEventRequest;
import com.heoby.detection.repository.DetectionRepository;
import com.heoby.global.common.entity.Detection;
import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.enums.DetectionType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class DetectionService {

  private final DetectionRepository detectionRepository;
  private static final String SNAPSHOT_PENDING = "";

  @Transactional
  public Detection createWildlifeDetection(Scarecrow scarecrow,
      DetectionType type,
      int count,
      String snapshotUrl) {

    String initial = (snapshotUrl != null && !snapshotUrl.isBlank())
        ? snapshotUrl
        : SNAPSHOT_PENDING;

    Detection detection = Detection.builder()
        .scarecrow(scarecrow)
        .type(type)
        .count(count)
        .snapshotUrl(initial)
        .createdAt(LocalDateTime.now())
        .build();

    return detectionRepository.save(detection);
  }

  @Transactional
  public Detection createIntruderDetection(Scarecrow scarecrow,
      AiEventRequest req,
      String snapshotUrl) {

    String initial = (snapshotUrl != null && !snapshotUrl.isBlank())
        ? snapshotUrl
        : SNAPSHOT_PENDING;

    Detection detection = Detection.builder()
        .scarecrow(scarecrow)
        .type(DetectionType.INTRUDER)
        .count(1)
        .snapshotUrl(initial)
        .createdAt(LocalDateTime.now())
        .build();

    return detectionRepository.save(detection);
  }

  @Transactional
  public Detection createFallDetection(Scarecrow scarecrow,
      AiEventRequest req,
      String snapshotUrl) {

    String initial = (snapshotUrl != null && !snapshotUrl.isBlank())
        ? snapshotUrl
        : SNAPSHOT_PENDING;

    Detection detection = Detection.builder()
        .scarecrow(scarecrow)
        .type(DetectionType.FALL_DETECTED)
        .count(1)
        .snapshotUrl(initial)
        .createdAt(LocalDateTime.now())
        .build();

    return detectionRepository.save(detection);
  }

  public DetectionType mapWildlifeToType(String species) {
    if (species == null) return DetectionType.OTHER;
    String s = species.trim().toLowerCase();

    if (s.contains("asiatic black bear")) {
      return DetectionType.BEAR;
    }
    if (s.contains("roe deer") || s.contains("water deer")) {
      return DetectionType.ROE_DEER;
    }
    if (s.contains("wild boar")) {
      return DetectionType.BOAR;
    }
    if (s.contains("great egret") || s.contains("grey heron")) {
      return DetectionType.MAGPIE;
    }
    return DetectionType.OTHER;
  }
}
