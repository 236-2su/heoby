package com.heoby.sensor.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.heoby.sensor.dto.Dht22Request;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.messaging.Message;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class SensorMessageHandler {

  private final SensorService sensorService;
  private final ObjectMapper objectMapper = new ObjectMapper();

  @ServiceActivator(inputChannel = "mqttInputChannel")
  public void handleMqtt(Message<String> msg) {
    String topic = (String) msg.getHeaders().get("mqtt_receivedTopic");
    String payload = msg.getPayload();

    log.info("📥 [MQTT-IN] Topic={} | Payload={}", topic, payload);

    try {
      Dht22Request req = objectMapper.readValue(payload, Dht22Request.class);
      log.info("🧩 [PARSED] deviceId={}, temp={}, humi={}, ts={}",
          req.deviceId(), req.temperature(), req.humidity(), req.timestamp());

      if (req.deviceId() == null || req.timestamp() == null) {
        log.warn("⚠️ [INVALID] Missing deviceId or timestamp in payload={}", payload);
        return;
      }

      log.info("➡️ [CALL] SensorService.upsertDhtByDeviceId({})", req.deviceId());
      sensorService.upsertDhtByDeviceId(req);

    } catch (Exception e) {
      log.error("❌ [MQTT] Parse/Service error: {} | Payload={}", e.getMessage(), payload, e);
    }
  }
}
