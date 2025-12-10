package com.heoby.alert.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record AlertItem(
    @JsonProperty("alert_uuid") String alertUuid,
    @JsonProperty("severity") String severity,          // CRITICAL / WARNING / INFO
    @JsonProperty("type") String type,                  // WILD_ANIMAL / INTRUDER / ...
    @JsonProperty("message") String message,
    @JsonProperty("scarecrow_uuid") String scarecrowUuid,
    @JsonProperty("scarecrow_name") String scarecrowName,
    @JsonProperty("lat") Double lat,
    @JsonProperty("lon") Double lon,
    @JsonProperty("occurred_at") String occurredAt,
    @JsonProperty("thumbnail_url") String thumbnailUrl,
    @JsonProperty("confidence") Double confidence,
    @JsonProperty("read") boolean read
) {}
