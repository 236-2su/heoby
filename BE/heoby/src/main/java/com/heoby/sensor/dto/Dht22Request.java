package com.heoby.sensor.dto;

public record Dht22Request(
    String deviceId,
    Double temperature,
    Double humidity,
    Long timestamp
) {}
