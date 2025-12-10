package com.heoby.fcm.repository;

import com.heoby.global.common.entity.DeviceToken;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.transaction.annotation.Transactional;

public interface DeviceTokenRepository extends JpaRepository<DeviceToken, Long> {

  Optional<DeviceToken> findByToken(String token);

  List<DeviceToken> findByUserUuidAndEnabledTrue(String userUuid);

  @Modifying(clearAutomatically = true, flushAutomatically = true)
  @Transactional
  @Query("update DeviceToken d set d.enabled = false, d.updatedAt = CURRENT_TIMESTAMP " +
      "where d.token = :token")
  int disableByToken(@Param("token") String token);

  @Modifying(clearAutomatically = true, flushAutomatically = true)
  @Transactional
  @Query("update DeviceToken d set d.lastSeenAt = :time, d.updatedAt = CURRENT_TIMESTAMP " +
      "where d.token = :token and d.enabled = true")
  int touchLastSeen(@Param("token") String token, @Param("time") LocalDateTime time);
}
