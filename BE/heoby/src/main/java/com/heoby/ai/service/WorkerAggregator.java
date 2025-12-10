package com.heoby.ai.service;

import com.heoby.global.common.entity.Scarecrow;
import com.heoby.sensor.service.SensorService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

/**
 * 같은 (serialNumber, timestamp_utc) 그룹에 들어온 사람 감지를
 * 1초간 모아 Set 크기로 카운트 → Sensor.worker 업데이트 (1회 커밋 보장)
 */
@Component
@RequiredArgsConstructor
public class WorkerAggregator {

  private final StringRedisTemplate redis;
  private final SensorService sensorService;

  public void enqueue(Scarecrow crow, String serialNumber, String tsUtc) {
    String setKey = setKey(serialNumber, tsUtc);
    redis.opsForSet().add(setKey, serialNumber + ":" + tsUtc);
    redis.expire(setKey, Duration.ofSeconds(10));

    String debounceKey = debounceKey(serialNumber, tsUtc);
    Boolean first = redis.opsForValue().setIfAbsent(debounceKey, "1", Duration.ofSeconds(10));
    if (Boolean.TRUE.equals(first)) {
      CompletableFuture.delayedExecutor(1, TimeUnit.SECONDS)
          .execute(() -> finalizeCount(crow, serialNumber, tsUtc));
    }
  }

  @Transactional
  void finalizeCount(Scarecrow crow, String serialNumber, String tsUtc) {
    String commitKey = commitKey(serialNumber, tsUtc);
    Boolean ok = redis.opsForValue().setIfAbsent(commitKey, "1", Duration.ofMinutes(1));
    if (!Boolean.TRUE.equals(ok)) return;

    String setKey = setKey(serialNumber, tsUtc);
    Long count = Optional.ofNullable(redis.opsForSet().size(setKey)).orElse(0L);

    sensorService.updateWorker(crow, count.intValue());
  }

  private String setKey(String serial, String ts)     { return "workers:" + serial + ":" + ts; }
  private String debounceKey(String serial, String ts){ return "workers:debounce:" + serial + ":" + ts; }
  private String commitKey(String serial, String ts)  { return "workers:commit:" + serial + ":" + ts; }
}
