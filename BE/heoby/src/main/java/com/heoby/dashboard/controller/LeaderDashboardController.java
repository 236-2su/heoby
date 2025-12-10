package com.heoby.dashboard.controller;

import com.heoby.alert.dto.AlarmListResponse;
import com.heoby.dashboard.dto.MapDetailResponse;
import com.heoby.dashboard.dto.MapResponse;
import com.heoby.dashboard.dto.ScarecrowListResponse;
import com.heoby.dashboard.dto.WeatherResponse;
import com.heoby.dashboard.dto.WorkerResponse;
import com.heoby.dashboard.service.LeaderDashboardService; // Changed to LeaderDashboardService
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/dashboard/leader")
@RequiredArgsConstructor
@Tag(name = "Leader Dashboard", description = "마을 이장 대시보드 조회 api")
public class LeaderDashboardController {

    private final LeaderDashboardService leaderDashboardService;

    @Operation(summary = "작업자수", description = "마을 전체 허수아비에 인식된 총 작업자 수를 반환합니다.")
    @GetMapping("/workers")
    public ResponseEntity<WorkerResponse> getWorkerCount(Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(leaderDashboardService.getWorkerCount(userUuid));
    }

    @Operation(summary = "허수아비목록", description = "마을 허수아비 전체 목록을 조회합니다.")
    @GetMapping("/scarecrows")
    public ResponseEntity<ScarecrowListResponse> getScarecrowLists(Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(leaderDashboardService.getScarecrows(userUuid));
    }

    @Operation(summary = "지도조회", description = "허수아비 아이디를 받아 허수아비의 위치를 반환합니다.")
    @GetMapping("/map/{crowId}")
    public ResponseEntity<MapResponse> getMap(@PathVariable String crowId, Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(leaderDashboardService.getMap(crowId, userUuid));
    }

    @Operation(summary = "지도상세조회", description = "허수아비 아이디를 받아 허수아비 위치, 야생동물 및 침입자 감지 데이터를 반환합니다. ")
    @GetMapping("/map/detail/{crowId}")
    public ResponseEntity<MapDetailResponse> getMapDetail(@PathVariable String crowId, Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(leaderDashboardService.getMapDetail(crowId, userUuid));
    }

    @Operation(summary = "알림", description = "마을 전체 알림 목록을 제공합니다.")
    @GetMapping("/alarms")
    public ResponseEntity<AlarmListResponse> getAlarms(Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(leaderDashboardService.getAlarms(userUuid));
    }

    @Operation(summary = "날씨조회", description = "허수아비 아이디를 받아 해당 위치의 이후 24시간 날씨를 반환합니다.")
    @GetMapping("/weather/{crowId}")
    public ResponseEntity<WeatherResponse> getWeather(
        @PathVariable String crowId, Authentication auth) {
        String userUuid = auth.getName();
        return ResponseEntity.ok(leaderDashboardService.getWeather(crowId, userUuid));
    }
}