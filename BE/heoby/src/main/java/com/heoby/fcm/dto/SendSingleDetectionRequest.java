package com.heoby.fcm.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public record SendSingleDetectionRequest(

    @Schema(description = "수신 대상 FCM 토큰")
    @NotBlank
    String token,

    @Schema(description = "표시/저장용 메시지 본문")
    @NotBlank
    String message,

    @Schema(description = "이벤트 타입")
    @NotBlank
    String type,

    @Schema(description = "심각도")
    @NotBlank
    String severity,

    @Schema(description = "스냅샷 이미지 URL")
    @NotBlank
    String snapshot_url
) {}
