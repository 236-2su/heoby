package com.heoby.alert.service;

import com.heoby.alert.repository.AlertRepository;
import com.heoby.fcm.repository.DeviceTokenRepository;
import com.heoby.fcm.service.FcmPushService;
import com.heoby.global.common.entity.Alert;
import com.heoby.global.common.entity.Detection;
import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.entity.Sensor;
import com.heoby.global.common.entity.User;
import com.heoby.global.common.enums.AlertSeverity;
import com.heoby.global.common.enums.Role;
import com.heoby.detection.repository.DetectionRepository;
import com.heoby.scarecrow.repository.ScarecrowRepository;
import com.heoby.sensor.repository.SensorRepository;
import com.heoby.user.repository.UserRepository;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AlertService {

  private final AlertRepository alertRepository;
  private final UserRepository userRepository;
  private final ScarecrowRepository scarecrowRepository;
  private final SensorRepository sensorRepository;
  private final DetectionRepository detectionRepository;
  private final DeviceTokenRepository deviceTokenRepository;
  private final FcmPushService fcmPushService;

  @Transactional
  public void emitDetectionAlert(
      String crowUuid,
      Long detectionId,
      AlertSeverity severity,
      String type,
      String title,
      String message,
      Double confidence,
      String thumbnailUrl
  ) {
    Scarecrow crow = scarecrowRepository.findById(crowUuid)
        .orElseThrow(() -> new IllegalArgumentException("Scarecrow not found: " + crowUuid));

    Sensor sensor = sensorRepository.findByScarecrow_CrowUuid(crowUuid).orElse(null);
    Double lat = (sensor != null) ? sensor.getLatitude() : null;
    Double lon = (sensor != null) ? sensor.getLongitude() : null;

    Detection detection = (detectionId != null)
        ? detectionRepository.findById(detectionId).orElse(null)
        : null;

    User sender = userRepository.findFirstByRole(Role.ADMIN)
        .orElseThrow(() -> new IllegalStateException(
            "No ADMIN user found in database. At least one ADMIN user must exist."));

    User owner = crow.getUser();
    Optional<User> leaderOpt = Optional.empty();
    if (owner != null) {
      leaderOpt = userRepository.findLeaderInSameVillageAs(owner.getUserUuid(), Role.LEADER);
    }

    Set<User> receivers = new HashSet<>();
    if (owner != null) receivers.add(owner);
    leaderOpt.ifPresent(receivers::add);

    for (User receiver : receivers) {
      String alertUuid = UUID.randomUUID().toString();

      Alert alert = Alert.builder()
          .alertUuid(alertUuid)
          .sender(sender)
          .receiver(receiver)
          .crowUuid(crowUuid)
          .detectionId(detectionId)
          .severity(severity)
          .message(message)
          .createdAt(LocalDateTime.now())
          .isRead(Boolean.FALSE)
          .build();

      alertRepository.save(alert);

      List<String> tokens = deviceTokenRepository.findByUserUuidAndEnabledTrue(receiver.getUserUuid())
          .stream()
          .map(dt -> dt.getToken())
          .filter(Objects::nonNull)
          .distinct()
          .collect(Collectors.toList());

      log.info("📨 FCM target user={} tokens={}", receiver.getUserUuid(), tokens);

      if (tokens.isEmpty()) continue;

      String notiTitle = switch (severity) {
        case CRITICAL -> "⚠️ 긴급 알림";
        case WARNING  -> "주의 알림";
        default       -> "알림";
      };
      String notiBody = (title != null && !title.isBlank()) ? title : message;

      Map<String, String> data = new LinkedHashMap<>();
      data.put("alert_uuid", alertUuid);
      data.put("severity", severity.name());
      data.put("type", (type != null && !type.isBlank())
          ? type
          : (detection != null && detection.getType() != null ? detection.getType().name() : "UNKNOWN"));
      data.put("message", message);
      data.put("crow_uuid", crowUuid);
      data.put("scarecrow_name", (crow.getCrowName() != null) ? crow.getCrowName() : "");
      data.put("occurred_at", alert.getCreatedAt().toString());
      String thumb = (thumbnailUrl != null && !thumbnailUrl.isBlank())
          ? thumbnailUrl
          : (detection != null ? String.valueOf(detection.getSnapshotUrl()) : "");
      data.put("thumbnail_url", thumb);
      if (confidence != null) data.put("confidence", String.valueOf(confidence));
      if (lat != null) data.put("lat", String.valueOf(lat));
      if (lon != null) data.put("lon", String.valueOf(lon));

      fcmPushService.sendToTokens(tokens, notiTitle, notiBody, data);
    }
  }

  @Transactional
  public void createWildlifeAlert(Detection detection) {
    if (detection == null || detection.getScarecrow() == null)
      throw new IllegalArgumentException("detection/scarecrow is null");

    String crowUuid = detection.getScarecrow().getCrowUuid();
    String type = detection.getType() != null ? detection.getType().name() : "WILDLIFE";
    String title = "야생동물 감지";
    String message = "허수아비 주변에서 야생동물이 감지되었습니다.";
    AlertSeverity severity = switch (type) {
      case "BOAR", "BEAR", "ROE_DEER" -> AlertSeverity.CRITICAL;
      default -> AlertSeverity.WARNING;
    };
    emitDetectionAlert(
        crowUuid,
        detection.getDetectionId(),
        severity,
        type,
        title,
        message,
        null,
        detection.getSnapshotUrl()
    );
  }

  @Transactional
  public void createIntruderAlert(Detection detection) {
    if (detection == null || detection.getScarecrow() == null)
      throw new IllegalArgumentException("detection/scarecrow is null");

    emitDetectionAlert(
        detection.getScarecrow().getCrowUuid(),
        detection.getDetectionId(),
        AlertSeverity.CRITICAL,
        "INTRUDER",
        "침입자 감지",
        "야간에 사람이 감지되었습니다.",
        null,
        detection.getSnapshotUrl()
    );
  }

  @Transactional
  public void createFallAlert(Detection detection) {
    if (detection == null || detection.getScarecrow() == null)
      throw new IllegalArgumentException("detection/scarecrow is null");

    emitDetectionAlert(
        detection.getScarecrow().getCrowUuid(),
        detection.getDetectionId(),
        AlertSeverity.CRITICAL,
        "FALL_DETECTED",
        "낙상 감지",
        "허수아비 주변에서 사람이 쓰러진 상태로 감지되었습니다.",
        null,
        detection.getSnapshotUrl()
    );
  }
}
