package com.heoby.dashboard.controller;

import com.heoby.alert.dto.AlarmListResponse;
import com.heoby.dashboard.dto.MapDetailResponse;
import com.heoby.dashboard.dto.MapResponse;
import com.heoby.dashboard.dto.ScarecrowListResponse;
import com.heoby.dashboard.dto.WeatherResponse;
import com.heoby.dashboard.dto.WorkerResponse;
import com.heoby.dashboard.service.DashboardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
@Tag(name = "Dashboard", description = "대시보드 조회 api")
public class DashboardController {

    private final DashboardService dashboardService;

    @Operation(summary = "작업자수", description = "유저의 허수아비에 인식된 총 작업자 수를 반환합니다.")
    @GetMapping("/workers")
    public ResponseEntity<WorkerResponse> getWorkerCount(Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(dashboardService.getWorkerCount(userUuid));
    }

    @Operation(summary = "허수아비목록", description = "마을 허수아비 전체 목록을 조회합니다.")
    @GetMapping("/scarecrows")
    public ResponseEntity<ScarecrowListResponse> getScarecrowLists(Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(dashboardService.getScarecrows(userUuid));
    }

    @Operation(summary = "지도조회", description = "허수아비 아이디를 받아 허수아비의 위치를 반환합니다.")
    @GetMapping("/map/{crowId}")
    public ResponseEntity<MapResponse> getMap(@PathVariable String crowId, Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(dashboardService.getMap(crowId, userUuid));
    }

    @Operation(summary = "지도상세조회", description = "허수아비 아이디를 받아 허수아비 위치, 야생동물 및 침입자 감지 데이터를 반환합니다. ")
    @GetMapping("/map/detail/{crowId}")
    public ResponseEntity<MapDetailResponse> getMapDetail(@PathVariable String crowId, Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(dashboardService.getMapDetail(crowId, userUuid));
    }

    @Operation(summary = "알림", description = "유저가 받은 알림 목록을 제공합니다.")
    @GetMapping("/alarms")
    public ResponseEntity<AlarmListResponse> getAlarms(Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(dashboardService.getAlarms(userUuid));
    }

    @Operation(summary = "알림 읽음 처리", description = "특정 알림을 읽음 상태로 변경합니다.")
    @PutMapping("/alarms/{alertUuid}")
    public ResponseEntity<Void> alarmRead(@PathVariable String alertUuid, Authentication auth) {
        String userUuid = auth.getName();
        dashboardService.alarmRead(alertUuid, userUuid);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "날씨조회", description = "허수아비 아이디를 받아 해당 위치의 이후 24시간 날씨를 반환합니다.")
    @GetMapping("/weather/{crowId}")
    public ResponseEntity<WeatherResponse> getWeather(
        @PathVariable String crowId, Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(dashboardService.getWeather(crowId, userUuid));
    }
}
