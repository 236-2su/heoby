package com.heoby.scarecrow.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record Location(
    @JsonProperty("lat") Double lat,
    @JsonProperty("lon") Double lon
) {}
