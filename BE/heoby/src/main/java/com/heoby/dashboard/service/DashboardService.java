package com.heoby.dashboard.service;

import com.heoby.alert.dto.AlarmListResponse;
import com.heoby.alert.repository.AlertRepository;
import com.heoby.dashboard.dto.MapDetailResponse;
import com.heoby.dashboard.dto.MapDetailResponse.WildlifeItem;
import com.heoby.dashboard.dto.MapResponse;
import com.heoby.dashboard.dto.ScarecrowListResponse;
import com.heoby.dashboard.dto.ScarecrowListResponse.ScarecrowItem;
import com.heoby.dashboard.dto.WeatherResponse;
import com.heoby.dashboard.dto.WeatherResponse.SensorBrief;
import com.heoby.dashboard.dto.WorkerResponse;
import com.heoby.detection.repository.DetectionRepository;
import com.heoby.global.common.entity.Alert;
import com.heoby.global.common.entity.Detection;
import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.entity.Sensor;
import com.heoby.global.common.enums.AlertSeverity;
import com.heoby.global.common.enums.ComponentStatus;
import com.heoby.global.common.enums.FileCategory;
import com.heoby.s3.service.S3Service;
import com.heoby.scarecrow.dto.Location;
import com.heoby.scarecrow.repository.ScarecrowRepository;
import com.heoby.sensor.repository.SensorRepository;
import com.heoby.user.repository.UserRepository;
import com.heoby.weather.KmaWeatherClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j; // [추가] 로그 확인용
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class DashboardService {

  private final ScarecrowRepository scarecrowRepository;
  private final SensorRepository sensorRepository;
  private final DetectionRepository detectionRepository;
  private final AlertRepository alertRepository;
  private final UserRepository userRepository;
  private final KmaWeatherClient kmaWeatherClient;
  private final S3Service s3Service;

  public WorkerResponse getWorkerCount(String userUuid) {
    int workers = sensorRepository.sumWorkerByUserUuid(userUuid);
    return new WorkerResponse(workers);
  }

  @Transactional(readOnly = true)
  public AlarmListResponse getAlarms(String userUuid) {
    var user = userRepository.findByUserUuid(userUuid)
        .orElseThrow(() -> new IllegalArgumentException("User not found"));

    var alerts = alertRepository.findAllByReceiverOrderByCreatedDesc(user.getUserUuid());

    var crowIds = alerts.stream().map(Alert::getCrowUuid)
        .filter(Objects::nonNull).distinct().toList();
    var detIds  = alerts.stream().map(Alert::getDetectionId)
        .filter(Objects::nonNull).distinct().toList();

    var scarecrowMap = scarecrowRepository.findByCrowUuidIn(crowIds).stream()
        .collect(Collectors.toMap(Scarecrow::getCrowUuid, s -> s));
    var sensorLocMap = sensorRepository.findByScarecrow_CrowUuidIn(crowIds).stream()
        .collect(Collectors.toMap(s -> s.getScarecrow().getCrowUuid(),
            s -> new AlarmListResponse.Location(s.getLatitude(), s.getLongitude())));
    var detectionMap = detectionRepository.findByDetectionIdIn(detIds).stream()
        .collect(Collectors.toMap(Detection::getDetectionId, d -> d));

    var items = alerts.stream().map(a -> {
      var sc  = scarecrowMap.get(a.getCrowUuid());
      var loc = sensorLocMap.get(a.getCrowUuid());
      var det = (a.getDetectionId() != null) ? detectionMap.get(a.getDetectionId()) : null;

      String snapshotUrl = null;
      if (det != null) {
        try {
          snapshotUrl = s3Service.getPresignedUrl(FileCategory.IMAGES, det.getDetectionId(), 0);
        } catch (Exception e) {
          log.warn("Failed to generate presigned URL for detectionId: {}", det.getDetectionId());
        }
      }

      return new AlarmListResponse.AlertItem(
          a.getAlertUuid(),
          a.getSeverity() != null ? a.getSeverity().name() : null,
          (det != null && det.getType() != null) ? det.getType().name() : null,
          a.getMessage(),
          a.getCrowUuid(),
          sc != null ? sc.getCrowName() : null,
          loc,
          a.getCreatedAt() != null ? a.getCreatedAt().toString() : null,
          snapshotUrl,
          Boolean.TRUE.equals(a.getIsRead())
      );
    }).toList();

    long totalUnread    = alertRepository.countUnread(user.getUserUuid());
    long criticalUnread = alertRepository.countUnreadBySeverity(user.getUserUuid(), AlertSeverity.CRITICAL);
    long warningUnread  = alertRepository.countUnreadBySeverity(user.getUserUuid(), AlertSeverity.WARNING);

    return new AlarmListResponse(
        new AlarmListResponse.Summary(criticalUnread, warningUnread, totalUnread),
        items
    );
  }

  @Transactional
  public void alarmRead(String alertUuid, String userUuid) {
    Alert alert = alertRepository.findById(alertUuid)
        .orElseThrow(() -> new IllegalArgumentException("Alert not found: " + alertUuid));

    if (!alert.getReceiver().getUserUuid().equals(userUuid)) {
      throw new org.springframework.security.access.AccessDeniedException("Forbidden alert access: " + alertUuid);
    }

    alert.setIsRead(true);
    alertRepository.save(alert);
  }

  @Transactional(readOnly = true)
  public ScarecrowListResponse getScarecrows(String userUuid) {
    List<Scarecrow> myScarecrows = scarecrowRepository.findMyScarecrows(userUuid);
    List<Scarecrow> villageScarecrows = scarecrowRepository.findVillageScarecrows(1L);

    Set<String> myCrowIds = myScarecrows.stream()
        .map(Scarecrow::getCrowUuid).collect(Collectors.toSet());

    List<Scarecrow> villageFiltered = villageScarecrows.stream()
        .filter(s -> !myCrowIds.contains(s.getCrowUuid()))
        .toList();

    List<ScarecrowItem> myItems = myScarecrows.stream().map(this::toItem).toList();
    List<ScarecrowItem> villageItems = villageFiltered.stream().map(this::toItem).toList();

    return new ScarecrowListResponse(myItems, villageItems);
  }

  private ScarecrowItem toItem(Scarecrow s) {
    var sensor = sensorRepository.findByScarecrow_CrowUuid(s.getCrowUuid()).orElse(null);

    Location location = null;
    Double temperature = null;
    Double humidity = null;

    if (sensor != null) {
      location = new Location(sensor.getLatitude(), sensor.getLongitude());
      temperature = sensor.getTemperature();
      humidity = sensor.getHumidity();
    }

    return new ScarecrowItem(
        s.getCrowUuid(),
        s.getCrowName(),
        s.getSerialNumber(),
        location,
        (s.getUser() != null) ? s.getUser().getUsername() : null,
        resolveStatus(s),
        s.getUpdatedAt() != null ? s.getUpdatedAt().toString() : null,
        temperature,
        humidity
    );
  }

  @Transactional(readOnly = true)
  public MapResponse getMap(String crowId, String userUuid) {
    Scarecrow crow = scarecrowRepository.findById(crowId)
        .orElseThrow(() -> new IllegalArgumentException("Scarecrow not found: " + crowId));

    if (crow.getUser() == null || !userUuid.equals(crow.getUser().getUserUuid())) {
      throw new org.springframework.security.access.AccessDeniedException("Forbidden scarecrow access: " + crowId);
    }

    var latestOpt = sensorRepository.findByScarecrow_CrowUuid(crowId);
    Location location = latestOpt
        .map(s -> new Location(s.getLatitude(), s.getLongitude()))
        .orElse(null);

    return new MapResponse(crow.getCrowUuid(), crow.getCrowName(), location);
  }

  @Transactional(readOnly = true)
  public MapDetailResponse getMapDetail(String crowId, String userUuid) {
    Scarecrow crow = scarecrowRepository.findById(crowId)
        .orElseThrow(() -> new IllegalArgumentException("Scarecrow not found: " + crowId));

    if (crow.getUser() == null || !userUuid.equals(crow.getUser().getUserUuid())) {
      throw new org.springframework.security.access.AccessDeniedException("Forbidden scarecrow access: " + crowId);
    }

    Sensor sensor = sensorRepository.findByScarecrow_CrowUuid(crowId).orElse(null);
    Location location = (sensor != null) ? new Location(sensor.getLatitude(), sensor.getLongitude()) : null;

    String status = resolveStatus(crow);

    var since = LocalDateTime.now().minusDays(30);
    List<Detection> detections = detectionRepository.findByCrowUuid(crowId, since);

    List<WildlifeItem> wildlife = detections.stream()
        .map(d -> {
          String url = null;
          try {
            url = s3Service.getPresignedUrl(FileCategory.IMAGES, d.getDetectionId(), 0);
          } catch (Exception e) {
            log.warn("Failed to generate presigned URL for detectionId: {}", d.getDetectionId());
          }

          return new WildlifeItem(
              String.valueOf(d.getDetectionId()),
              d.getType() != null ? d.getType().name() : null,
              d.getCount(),
              d.getCreatedAt() != null ? d.getCreatedAt().toString() : null,
              url
          );
        }).toList();

    return new MapDetailResponse(crow.getCrowUuid(), crow.getCrowName(), location, status, wildlife);
  }

  @Transactional(readOnly = true)
  public WeatherResponse getWeather(String crowId, String userUuid) {
    var crow = scarecrowRepository.findById(crowId)
        .orElseThrow(() -> new IllegalArgumentException("Scarecrow not found: " + crowId));

    if (crow.getUser() == null || !userUuid.equals(crow.getUser().getUserUuid())) {
      throw new org.springframework.security.access.AccessDeniedException("Forbidden scarecrow access: " + crowId);
    }

    var sensor = sensorRepository.findByScarecrow_CrowUuid(crowId)
        .orElseThrow(() -> new IllegalArgumentException("Sensor not found for crow: " + crowId));

    Location location = new Location(sensor.getLatitude(), sensor.getLongitude());
    SensorBrief sensorBrief = new SensorBrief(sensor.getTemperature(), sensor.getHumidity());
    var forecast = kmaWeatherClient.fetch24hForecast(sensor.getLatitude(), sensor.getLongitude());

    return new WeatherResponse(location, sensorBrief, forecast);
  }

  private String resolveStatus(Scarecrow s) {
    ComponentStatus[] components = {
        s.getCameraStatus(), s.getThermalSensorStatus(), s.getSpeakerStatus(), s.getLightStatus()
    };
    boolean hasError = false;
    boolean hasDisconnected = false;

    for (ComponentStatus c : components) {
      if (c == null) continue;
      if (c == ComponentStatus.ERROR) { hasError = true; break; }
      if (c == ComponentStatus.DISCONNECTED) hasDisconnected = true;
    }
    if (hasError) return "CRITICAL";
    if (hasDisconnected) return "WARNING";
    return "NORMAL";
  }
}