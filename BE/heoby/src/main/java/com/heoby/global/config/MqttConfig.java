package com.heoby.global.config;

import jakarta.annotation.PostConstruct;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.core.MessageProducer;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.messaging.MessageChannel;

@Configuration
public class MqttConfig {

  @Value("${heoby.mqtt.broker-url}") private String brokerUrl;
  @Value("${heoby.mqtt.username:}") private String username;
  @Value("${heoby.mqtt.password:}") private String password;
  @Value("${heoby.mqtt.client-id}") private String clientId;
  @Value("${heoby.mqtt.topic}") private String topicFilter;
  @Value("${heoby.mqtt.qos:1}") private int qos;

  @Value("${heoby.mqtt.ssl.enable:false}") private boolean sslEnable;
  @Value("${heoby.mqtt.ssl.ca-path:/etc/ssl/certs/ca-certificates.crt}") private String caPath;

  @Bean
  public MqttPahoClientFactory mqttClientFactory() {
    var factory = new DefaultMqttPahoClientFactory();
    var opts = new MqttConnectOptions();
    opts.setServerURIs(new String[]{brokerUrl});
    if (!username.isBlank()) opts.setUserName(username);
    if (!password.isBlank()) opts.setPassword(password.toCharArray());
    opts.setCleanSession(true);
    opts.setAutomaticReconnect(true);

    factory.setConnectionOptions(opts);
    return factory;
  }

  @Bean
  public MessageChannel mqttInputChannel() {
    return new DirectChannel();
  }

  @Bean
  public MessageProducer inbound(MqttPahoClientFactory factory) {
    var adapter = new MqttPahoMessageDrivenChannelAdapter(clientId, factory, topicFilter);
    adapter.setQos(qos);
    adapter.setOutputChannel(mqttInputChannel());
    return adapter;
  }

  @PostConstruct
  public void checkEnv() {
    System.out.println("[MQTT-CONFIG] brokerUrl=" + brokerUrl + ", topic=" + topicFilter + ", username=" + username);
  }
}

