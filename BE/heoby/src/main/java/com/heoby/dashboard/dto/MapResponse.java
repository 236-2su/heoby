package com.heoby.dashboard.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.heoby.scarecrow.dto.Location;

public record MapResponse(
    @JsonProperty("scarecrow_uuid") String scarecrowUuid,
    @JsonProperty("name") String name,
    @JsonProperty("location") Location location
) {}

