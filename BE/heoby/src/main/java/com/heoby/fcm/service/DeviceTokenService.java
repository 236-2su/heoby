package com.heoby.fcm.service;

import com.heoby.fcm.repository.DeviceTokenRepository;
import com.heoby.global.common.entity.DeviceToken;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class DeviceTokenService {

  private final DeviceTokenRepository repo;

  /** 토큰 등록/업서트 */
  @Transactional
  public void register(String userUuid, String platform, String token) {
    var opt = repo.findByToken(token);
    if (opt.isPresent()) {
      var dt = opt.get();
      dt.setEnabled(Boolean.TRUE);
      // 유저/플랫폼이 바뀌었으면 최신화
      if (!userUuid.equals(dt.getUserUuid())) dt.setUserUuid(userUuid);
      if (!platform.equals(dt.getPlatform())) dt.setPlatform(platform);
      dt.setLastSeenAt(LocalDateTime.now());
      // JPA 영속 상태면 save 불필요
    } else {
      var dt = DeviceToken.builder()
          .userUuid(userUuid)
          .platform(platform)
          .token(token)
          .enabled(Boolean.TRUE)
          .lastSeenAt(LocalDateTime.now())
          .build();
      repo.save(dt);
    }
  }

  /** 토큰 비활성화 (로그아웃/해제) */
  @Transactional
  public void unregister(String token) {
    // 효율을 위해 업데이트 쿼리 사용 (존재하지 않아도 예외 없이 0건 처리)
    repo.disableByToken(token);
  }
}
