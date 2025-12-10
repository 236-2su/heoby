package com.heoby.fcm.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.Map;

public record ToSingleRequest(
    @Schema(description = "수신 대상 FCM 토큰")
    String token,

    @Schema(description = "표시/저장용 메시지 본문")
    String message,

    @Schema(description = "추가 데이터 (alert_uuid, severity 등)")
    Map<String, String> data
) {}
