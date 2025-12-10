package com.heoby.alert.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public record AlarmListResponse(
    @JsonProperty("summary") Summary summary,
    @JsonProperty("alerts") List<AlertItem> alerts
) {
  public record Summary(
      @JsonProperty("critical_unread") long criticalUnread,
      @JsonProperty("warning_unread") long warningUnread,
      @JsonProperty("total_unread") long totalUnread
  ) {}

  public record AlertItem(
      @JsonProperty("alert_uuid") String alertUuid,
      @JsonProperty("severity") String severity,      // Alert.severity
      @JsonProperty("type") String type,              // Detection.type (nullable)
      @JsonProperty("message") String message,        // Alert.message
      @JsonProperty("scarecrow_uuid") String scarecrowUuid,
      @JsonProperty("scarecrow_name") String scarecrowName,
      @JsonProperty("location") Location location,    // Sensor(lat/lon)
      @JsonProperty("occurred_at") String occurredAt, // Alert.createdAt
      @JsonProperty("snapshot_url") String snapshotUrl, // Detection.snapshotUrl (nullable)
      @JsonProperty("read") boolean read
  ) {}

  public record Location(
      @JsonProperty("lat") Double lat,
      @JsonProperty("lon") Double lon
  ) {}
}
