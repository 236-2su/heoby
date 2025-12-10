package com.heoby.dashboard.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.heoby.scarecrow.dto.Location;
import java.util.List;

public record MapDetailResponse(
    @JsonProperty("scarecrow_uuid") String scarecrowUuid,
    @JsonProperty("name") String name,
    @JsonProperty("location") Location location,
    @JsonProperty("status") String status,
    @JsonProperty("wildlife") List<WildlifeItem> wildlife
) {

  public record WildlifeItem(
      @JsonProperty("detection_id") String detectionId,
      @JsonProperty("type") String type,
      @JsonProperty("count") Integer count,
      @JsonProperty("occurred_at") String occurredAt,
      @JsonProperty("snapshot_url") String snapshotUrl
  ) {}
}
