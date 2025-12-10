package com.heoby.fcm.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public record RegisterTokenRequest(
    @Schema(description = "유저 UUID")
    @NotBlank
    String userUuid,

    @Schema(description = "플랫폼")
    @NotBlank
    String platform,

    @Schema(description = "FCM Registration Token")
    @NotBlank
    String token
) {}
