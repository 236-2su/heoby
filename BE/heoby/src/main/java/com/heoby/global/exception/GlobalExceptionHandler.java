package com.heoby.global.exception;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 전역 예외 처리기
 * - @RestControllerAdvice: 전 컨트롤러 전역 적용
 * - @ExceptionHandler: 특정 예외를 JSON 응답으로 변환
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    // Bean Validation 예외 처리 (@Valid 실패)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidationException(MethodArgumentNotValidException ex,
        HttpServletRequest req) {
        List<Map<String, String>> errors = ex.getBindingResult().getFieldErrors().stream()
            .map(field -> Map.of(
                "field", field.getField(),
                "message", field.getDefaultMessage()))
            .toList();

        var firstMsg = errors.isEmpty() ? "잘못된 요청입니다." : errors.get(0).get("message");
        var body = ApiErrorResponse.of("BAD_REQUEST", firstMsg,
            HttpStatus.BAD_REQUEST.value(), req.getRequestURI(), errors);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    // 커스텀 예외 처리
    @ExceptionHandler(CustomException.class)
    public ResponseEntity<ApiErrorResponse> handleCustomException(CustomException ex,
        HttpServletRequest req) {
        var status = ex.getStatus();
        var body = ApiErrorResponse.of(status.name(), ex.getMessage(),
            status.value(), req.getRequestURI());
        return ResponseEntity.status(status).body(body);
    }

    // 그 외 모든 예외 처리 (시스템 오류 등)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleAllException(Exception ex,
        HttpServletRequest req) {
        var body = ApiErrorResponse.of("INTERNAL_SERVER_ERROR",
            ex.getMessage(), 500, req.getRequestURI());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }

}
