package com.heoby.ai.service;

import com.heoby.alert.service.AlertService;
import com.heoby.detection.service.DetectionService;
import com.heoby.global.common.entity.Detection;
import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.enums.DetectionType;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
public class WildlifeAggregator {

  private final StringRedisTemplate redis;
  private final DetectionService detectionService;
  private final AlertService alertService;
  private final MqttPublishBridge mqttBridge;
  private final SnapshotStorageService snapshotStorageService;

  public void enqueue(Scarecrow scarecrow,
      String serialNumber,
      String timestampUtc,
      String species,
      String base64Image) {

    DetectionType type = detectionService.mapWildlifeToType(species);
    String typeKey = type.name();

    String countKey    = countKey(serialNumber, timestampUtc);
    String snapKey     = snapshotKey(serialNumber, timestampUtc);
    String debounceKey = debounceKey(serialNumber, timestampUtc);

    redis.opsForHash().increment(countKey, typeKey, 1);
    redis.expire(countKey, Duration.ofSeconds(20));

    if (base64Image != null && !base64Image.isBlank()) {
      redis.opsForHash().put(snapKey, typeKey, base64Image);
      redis.expire(snapKey, Duration.ofSeconds(20));
    }

    Boolean first = redis.opsForValue().setIfAbsent(debounceKey, "1", Duration.ofSeconds(10));
    if (Boolean.TRUE.equals(first)) {
      CompletableFuture.delayedExecutor(1, TimeUnit.SECONDS)
          .execute(() -> finalizeForTimestamp(scarecrow, serialNumber, timestampUtc));
    }
  }

  @Transactional
  protected void finalizeForTimestamp(Scarecrow scarecrow,
      String serialNumber,
      String timestampUtc) {

    String commitKey = commitKey(serialNumber, timestampUtc);
    Boolean ok = redis.opsForValue().setIfAbsent(commitKey, "1", Duration.ofMinutes(1));
    if (!Boolean.TRUE.equals(ok)) {
      return;
    }

    String countKey = countKey(serialNumber, timestampUtc);
    String snapKey  = snapshotKey(serialNumber, timestampUtc);

    Map<Object, Object> counts = redis.opsForHash().entries(countKey);
    if (counts == null || counts.isEmpty()) {
      return;
    }

    for (Map.Entry<Object, Object> entry : counts.entrySet()) {
      String typeName = (String) entry.getKey();
      int count = Integer.parseInt(entry.getValue().toString());

      DetectionType type = DetectionType.valueOf(typeName);

      String base64 = Optional.ofNullable(
          (String) redis.opsForHash().get(snapKey, typeName)
      ).orElse(null);

      Detection detection = detectionService.createWildlifeDetection(
          scarecrow,
          type,
          count,
          null
      );

      snapshotStorageService.storeDetectionSnapshot(detection, base64);
      alertService.createWildlifeAlert(detection);
      mqttBridge.publishWildlife(detection);
    }
  }

  private String countKey(String serial, String ts)   { return "wildlife:" + serial + ":" + ts + ":cnt"; }
  private String snapshotKey(String serial, String ts){ return "wildlife:" + serial + ":" + ts + ":snap"; }
  private String debounceKey(String serial, String ts){ return "wildlife:" + serial + ":" + ts + ":debounce"; }
  private String commitKey(String serial, String ts)  { return "wildlife:" + serial + ":" + ts + ":commit"; }
}
