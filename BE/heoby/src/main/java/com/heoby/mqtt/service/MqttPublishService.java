package com.heoby.mqtt.service;

import java.util.Map;

public interface MqttPublishService {

  void publishJson(String topic, Map<String, Object> payload);
}
