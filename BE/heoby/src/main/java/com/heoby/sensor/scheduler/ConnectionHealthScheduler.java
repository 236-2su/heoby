package com.heoby.sensor.scheduler;

import com.heoby.global.common.enums.ComponentStatus;
import com.heoby.scarecrow.repository.ScarecrowRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Component
@RequiredArgsConstructor
public class ConnectionHealthScheduler {

  private final ScarecrowRepository scarecrowRepository;

  @Scheduled(fixedDelay = 60_000L)
  @Transactional
  public void markThermoHygrometerOfflineIfNoData() {
    var threshold = LocalDateTime.now().minusMinutes(5);
    int changed = scarecrowRepository.markThermoHygrometerOfflineBefore(
        threshold, ComponentStatus.DISCONNECTED
    );

    if (changed > 0) {
      log.info("[Scheduler] 온습도센서 {}개 DISCONNECTED 처리됨", changed);
    }
  }
}
