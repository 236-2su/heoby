package com.heoby.mqtt.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class MqttPublishServiceImpl implements MqttPublishService {

  @Value("${heoby.mqtt.broker-url}")
  private String brokerUrl;

  @Value("${heoby.mqtt.username:}")
  private String username;

  @Value("${heoby.mqtt.password:}")
  private String password;

  @Value("${heoby.mqtt.client-id}")
  private String clientId;          // inbound와 동일 prefix 사용

  @Value("${heoby.mqtt.qos:1}")
  private int qos;

  private final ObjectMapper mapper = new ObjectMapper();

  private IMqttClient client;

  private synchronized IMqttClient getClient() throws MqttException {
    if (client != null && client.isConnected()) {
      return client;
    }

    String publisherId = clientId + "-pub";

    MqttConnectOptions opts = new MqttConnectOptions();
    opts.setServerURIs(new String[]{brokerUrl});
    if (username != null && !username.isBlank()) {
      opts.setUserName(username);
    }
    if (password != null && !password.isBlank()) {
      opts.setPassword(password.toCharArray());
    }
    opts.setCleanSession(true);
    opts.setAutomaticReconnect(true);

    client = new MqttClient(brokerUrl, publisherId);
    client.connect(opts);

    log.info("MQTT publisher connected: broker={} clientId={}", brokerUrl, publisherId);
    return client;
  }

  @Override
  public void publishJson(String topic, Map<String, Object> payload) {
    try {
      IMqttClient c = getClient();

      String json = mapper.writeValueAsString(payload);
      MqttMessage msg = new MqttMessage(json.getBytes(StandardCharsets.UTF_8));
      msg.setQos(qos);
      msg.setRetained(false);

      c.publish(topic, msg);
      log.info("MQTT published: topic={} qos={} payload={}", topic, qos, json);

    } catch (Exception e) {
      log.error("MQTT publish failed: topic={} payload={} error={}",
          topic, payload, e.getMessage(), e);
    }
  }
}
