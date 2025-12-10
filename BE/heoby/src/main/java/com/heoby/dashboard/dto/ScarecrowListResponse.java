package com.heoby.dashboard.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.heoby.scarecrow.dto.Location;
import java.util.List;

public record ScarecrowListResponse(
    @JsonProperty("my_scarecrows") List<ScarecrowItem> myScarecrows,
    @JsonProperty("village_scarecrows") List<ScarecrowItem> villageScarecrows
) {
  public record ScarecrowItem(
      @JsonProperty("scarecrow_uuid") String scarecrowUuid,
      @JsonProperty("name") String name,
      @JsonProperty("serial_number") String serialNumber,
      @JsonProperty("location") Location location,
      @JsonProperty("owner_name") String ownerName,
      @JsonProperty("status") String status,
      @JsonProperty("updated_at") String updatedAt,
      @JsonProperty("temperature") Double temperature,
      @JsonProperty("humidity") Double humidity
  ) {}
}