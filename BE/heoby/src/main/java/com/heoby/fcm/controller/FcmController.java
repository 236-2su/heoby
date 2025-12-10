package com.heoby.fcm.controller;

import com.heoby.fcm.dto.*;
import com.heoby.fcm.service.DeviceTokenService;
import com.heoby.fcm.service.FcmPushService;
import jakarta.validation.Valid;
import java.util.LinkedHashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/fcm")
@RequiredArgsConstructor
public class FcmController {

  private final FcmPushService fcmPushService;
  private final DeviceTokenService deviceTokenService;

  @PostMapping("/register")
  public RegisterTokenResponse register(@Valid @RequestBody RegisterTokenRequest req) {
    deviceTokenService.register(req.userUuid(), req.platform(), req.token());
    return new RegisterTokenResponse("등록 완료", req.token());
  }

  @PostMapping("/unregister")
  public UnregisterTokenResponse unregister(@Valid @RequestBody UnregisterTokenRequest req) {
    deviceTokenService.unregister(req.token());
    return new UnregisterTokenResponse("해제 완료");
  }

  @PostMapping("/send")
  public SingleFcmResponse sendSingle(@Valid @RequestBody SendSingleDetectionRequest req) {

    Map<String, String> data = new LinkedHashMap<>();
    data.put("type", req.type());
    data.put("severity", req.severity());
    data.put("snapshot_url", req.snapshot_url());

    fcmPushService.sendToToken(req.token(), null, req.message(), data);

    return new SingleFcmResponse("단일 발송 요청 완료", 1);
  }

  @PostMapping("/send-multi")
  public MultiFcmResponse sendMulti(@RequestBody ToMultiRequest req) {
    var result = fcmPushService.sendToTokensWithResult(req.tokens(), null, req.message(), req.data());
    return new MultiFcmResponse(
        "다중 발송 요청 완료",
        result.requested(),
        result.success(),
        result.failure(),
        result.disabled(),
        result.retried()
    );
  }
}
