package com.heoby.ai.service;

import com.heoby.ai.dto.AiEventRequest;
import com.heoby.alert.service.AlertService;
import com.heoby.detection.service.DetectionService;
import com.heoby.global.common.entity.Detection;
import com.heoby.global.common.entity.Scarecrow;
import com.heoby.scarecrow.repository.ScarecrowRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Duration; // [추가] 시간 차이 계산용
import java.time.LocalDateTime; // [추가]
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap; // [추가] Thread-safe한 맵

@Service
@RequiredArgsConstructor
public class AiIngestService {

  private final ScarecrowRepository scarecrowRepo;
  private final DetectionService detectionService;
  private final AlertService alertService;
  private final MqttPublishBridge mqttBridge;
  private final WorkerAggregator workerAggregator;
  private final WildlifeAggregator wildlifeAggregator;
  private final DayNightService dayNightService;
  private final SnapshotStorageService snapshotStorageService;

  private static final int FALL_DURATION_THRESHOLD_SECONDS = 300;
  private static final int FALL_COOLDOWN_MINUTES = 10;
  private final Map<String, LocalDateTime> lastFallAlertMap = new ConcurrentHashMap<>();

  public Map<String, Object> handleEvent(AiEventRequest req) {

    Scarecrow scarecrow = scarecrowRepo.findBySerialNumber(req.stream_id())
        .orElseThrow(() ->
            new IllegalArgumentException("Unknown serialNumber: " + req.stream_id()));

    switch (req.category()) {
      case "wildlife" -> {
        wildlifeAggregator.enqueue(
            scarecrow,
            req.stream_id(),
            req.timestamp_utc(),
            req.species(),
            req.image_jpeg_base64()
        );
        return Map.of("status", "wildlife-queued");
      }

      case "human" -> {
        boolean isLying = "lying".equalsIgnoreCase(req.pose_label());

        boolean isLongDuration = req.duration_seconds() != null
            && req.duration_seconds() >= FALL_DURATION_THRESHOLD_SECONDS;

        if (isLying && isLongDuration) {
          String crowUuid = scarecrow.getCrowUuid();
          LocalDateTime lastAlertTime = lastFallAlertMap.get(crowUuid);
          LocalDateTime now = LocalDateTime.now();

          if (lastAlertTime != null) {
            long minutesSinceLast = Duration.between(lastAlertTime, now).toMinutes();
            if (minutesSinceLast < FALL_COOLDOWN_MINUTES) {
              return Map.of("status", "human-fall-ignored-cooldown", "timeLeft", (FALL_COOLDOWN_MINUTES - minutesSinceLast) + "min");
            }
          }

          Detection detection = detectionService.createFallDetection(
              scarecrow,
              req,
              null
          );

          snapshotStorageService.storeDetectionSnapshot(detection, req.image_jpeg_base64());
          alertService.createFallAlert(detection);
          mqttBridge.publishFallDetected(detection);

          lastFallAlertMap.put(crowUuid, now);

          return Map.of("status", "human-fall-processed");
        }

        if (dayNightService.isDaytime(req.timestamp_utc())) {
          workerAggregator.enqueue(scarecrow, req.stream_id(), req.timestamp_utc());
          return Map.of("status", "human-day-queued");
        } else {
          Detection detection = detectionService.createIntruderDetection(
              scarecrow,
              req,
              null
          );

          snapshotStorageService.storeDetectionSnapshot(detection, req.image_jpeg_base64());
          alertService.createIntruderAlert(detection);
          mqttBridge.publishIntruder(detection);
          return Map.of("status", "human-night-processed");
        }
      }

      default -> throw new IllegalArgumentException("Invalid category: " + req.category());
    }
  }
}