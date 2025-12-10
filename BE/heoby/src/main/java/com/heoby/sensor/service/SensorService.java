package com.heoby.sensor.service;

import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.entity.Sensor;
import com.heoby.global.common.enums.ComponentStatus;
import com.heoby.scarecrow.repository.ScarecrowRepository;
import com.heoby.sensor.repository.SensorRepository;
import com.heoby.sensor.dto.Dht22Request;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Slf4j
@Service
@RequiredArgsConstructor
public class SensorService {

  private final ScarecrowRepository scarecrowRepository;
  private final SensorRepository sensorRepository;

  @Transactional
  public void upsertDhtByDeviceId(Dht22Request req) {
    log.info("🔎 [SERVICE] Start upsert for deviceId={}", req.deviceId());

    var crow = scarecrowRepository.findBySerialNumber(req.deviceId()).orElse(null);
    if (crow == null) {
      log.warn("❌ [SERVICE] Scarecrow not found for serial={}", req.deviceId());
      return;
    }

    log.info("✅ [FOUND] crowUuid={} (serial={})", crow.getCrowUuid(), crow.getSerialNumber());

    var sensor = sensorRepository.findByScarecrow_CrowUuid(crow.getCrowUuid())
        .orElseGet(() -> {
          log.info("🆕 [NEW] Creating new Sensor for crow={}", crow.getCrowUuid());
          return Sensor.builder().scarecrow(crow).build();
        });

    sensor.setTemperature(req.temperature());
    sensor.setHumidity(req.humidity());
    log.info("🌡 [UPDATE] temp={}, humi={}", req.temperature(), req.humidity());

    if (req.timestamp() != null) {
      var ts = LocalDateTime.ofInstant(Instant.ofEpochSecond(req.timestamp()), ZoneOffset.UTC);
      sensor.setUpdatedAt(ts);
      if (sensor.getCreatedAt() == null) sensor.setCreatedAt(ts);
      log.info("⏱ [TIMESTAMP] updatedAt={}", ts);
    }

    sensorRepository.save(sensor);
    log.info("💾 [SAVED] Sensor updated for crow={}", crow.getCrowUuid());

    if (crow.getThermohygrometerSensorStatus() != ComponentStatus.CONNECTED) {
      crow.setThermohygrometerSensorStatus(ComponentStatus.CONNECTED);
      scarecrowRepository.save(crow);
      log.info("🔗 [STATUS] thermohygrometerSensorStatus → CONNECTED (crow={})", crow.getCrowUuid());
    }

    log.info("✅ [COMMIT] deviceId={} | Temp={} | Humi={}",
        req.deviceId(), req.temperature(), req.humidity());
  }

  @Transactional
  public void updateWorker(Scarecrow crow, int worker) {
    var sOpt = sensorRepository.findTopByScarecrowOrderByUpdatedAtDesc(crow);
    var s = sOpt.orElseGet(() -> com.heoby.global.common.entity.Sensor.builder()
        .scarecrow(crow)
        .worker(0)
        .build());
    s.setWorker(worker);
    sensorRepository.save(s);
  }

}
