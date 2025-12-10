package com.heoby.global.health;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.HashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Health Check", description = "서버 상태 확인용 API")
@RestController
public class HealthCheckController {

    @Operation(summary = "서버 상태 확인", description = "서버가 정상적으로 작동 중인지 확인합니다.")
    @GetMapping("/health")
    public Map<String, Object> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("message", "Heoby backend is running normally");
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

}
