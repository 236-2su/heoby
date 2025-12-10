package com.heoby.scarecrow.service;

import com.heoby.global.common.enums.ComponentStatus;
import com.heoby.scarecrow.repository.ScarecrowRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
public class ScarecrowService {

  private final ScarecrowRepository scarecrowRepository;

  // 매 1분마다 검사
  @Scheduled(fixedDelay = 60_000L, initialDelay = 30_000L)
  @Transactional
  public void markThermoHygrometerOfflineIfNoHeartbeat() {
    var threshold = LocalDateTime.now().minusMinutes(5);
    int changed = scarecrowRepository
        .markThermoHygrometerOfflineBefore(threshold, ComponentStatus.DISCONNECTED);
    if (changed > 0) {
      System.out.println("[Scheduler] 온습도센서 DISCONNECTED 처리: " + changed + " (threshold=" + threshold + ")");
    }
  }
}
