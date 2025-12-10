package com.heoby.auth.controller;

import com.heoby.auth.dto.request.LoginRequest;
import com.heoby.auth.dto.request.RefreshRequest;
import com.heoby.auth.dto.request.SignupRequest;
import com.heoby.auth.dto.response.LoginResponse;
import com.heoby.auth.dto.response.TokenResponse;
import com.heoby.auth.service.AuthService;
import com.heoby.auth.service.AuthServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Auth", description = "회원가입, 로그인, 토큰 갱신 및 로그아웃 API")
public class AuthController {
    private final AuthService authService;

    @Operation(summary = "회원가입", description = "이메일, 비밀번호, 이름 정보를 받아 회원가입을 수행합니다.")
    @PostMapping("/signup")
    public ResponseEntity<Void> signup(@RequestBody @Valid SignupRequest req) {
        authService.signup(req);
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "로그인", description = "이메일과 비밀번호로 로그인하고 액세스·리프레시 토큰을 발급합니다.")
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody @Valid LoginRequest req) {
        return ResponseEntity.ok(authService.login(req));
    }

    @Operation(summary = "토큰 갱신", description = "리프레시 토큰을 이용해 새로운 액세스 토큰을 발급받습니다.")
    @PostMapping("/refresh")
    public ResponseEntity<TokenResponse> refresh(@RequestBody @Valid RefreshRequest req) {
        return ResponseEntity.ok(authService.refresh(req));
    }

    @Operation(summary = "로그아웃", description = "리프레시 토큰을 무효화하여 로그아웃을 처리합니다.")
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(
            @Parameter(hidden = true) @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @RequestBody @Valid RefreshRequest req) {
        authService.logout(authorization, req);
        return ResponseEntity.noContent().build();
    }

}
