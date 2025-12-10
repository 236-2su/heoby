package com.heoby.fcm.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public record UnregisterTokenRequest(
    @Schema(description = "비활성화할 FCM Registration Token")
    @NotBlank
    String token
) {}
