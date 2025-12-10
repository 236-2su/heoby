package com.heoby.global.exception;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public record ApiErrorResponse(
    String error,            // 예: BAD_REQUEST, UNAUTHORIZED, FORBIDDEN
    String message,          // 사용자 메시지
    int status,              // HTTP 상태코드
    String path,             // 요청 경로
    LocalDateTime timestamp, // 발생 시각
    List<Map<String,String>> errors // 필드 검증 오류 (선택)
) {
    public static ApiErrorResponse of(String error, String message, int status, String path) {
        return new ApiErrorResponse(error, message, status, path, LocalDateTime.now(), null);
    }
    public static ApiErrorResponse of(String error, String message, int status, String path, List<Map<String,String>> errors) {
        return new ApiErrorResponse(error, message, status, path, LocalDateTime.now(), errors);
    }

}
