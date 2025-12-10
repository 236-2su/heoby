package com.heoby.ai.service;

import com.heoby.global.common.entity.Detection;
import com.heoby.mqtt.service.MqttPublishService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
@RequiredArgsConstructor
public class MqttPublishBridge {

  private final MqttPublishService mqtt;

  public void publishWildlife(Detection ctx) {
    String serial = ctx.getScarecrow().getSerialNumber();
    String topic  = "heoby/" + serial + "/command";

    int durationSeconds = 15;

    Map<String, Object> payload = Map.of(
        "type", ctx.getType().name(),      // 예: BOAR / BEAR / ROE_DEER ...
        "count", ctx.getCount(),           // 해당 타입의 감지된 마릿수
        "durationSeconds", durationSeconds // 조명/사이렌 유지 시간(초)
    );

    mqtt.publishJson(topic, payload);
  }

  public void publishIntruder(Detection ctx) {
    String serial = ctx.getScarecrow().getSerialNumber();
    String topic  = "heoby/" + serial + "/command";

    int durationSeconds = 15;

    Map<String, Object> payload = Map.of(
        "type", ctx.getType().name(),
        "count", ctx.getCount(),
        "durationSeconds", durationSeconds
    );

    mqtt.publishJson(topic, payload);
  }

  public void publishFallDetected(Detection ctx) {
    String serial = ctx.getScarecrow().getSerialNumber();
    String topic  = "heoby/" + serial + "/command";

    int durationSeconds = 15;

    Map<String, Object> payload = Map.of(
        "type", ctx.getType().name(),
        "count", ctx.getCount(),
        "durationSeconds", durationSeconds
    );

    mqtt.publishJson(topic, payload);
  }
}
