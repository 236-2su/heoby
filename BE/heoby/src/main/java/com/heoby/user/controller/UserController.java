package com.heoby.user.controller;

import com.heoby.global.common.entity.User;
import com.heoby.user.dto.request.UserDeleteRequest;
import com.heoby.user.dto.request.UserUpdateRequest;
import com.heoby.user.dto.response.UserResponse;
import com.heoby.user.repository.UserRepository;
import java.util.Map;

import com.heoby.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@Tag(name = "User", description = "회원 관련 API")
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    private final UserRepository userRepository;

    private final UserService userService;

    @Operation(summary = "내 정보 조회", description = "로그인한 사용자의 프로필 정보를 반환합니다.")
    @GetMapping("/me")
    public ResponseEntity<UserResponse> getMe() {
        String userUuid = currentUserUuid();
        return ResponseEntity.ok(userService.getMe(userUuid));
    }

    @Operation(summary = "회원정보 수정", description = "username 및 userVillageId를 수정합니다.")
    @PatchMapping("/me")
    public ResponseEntity<Void> updateUser(@RequestBody @Valid UserUpdateRequest req) {
        String userUuid = currentUserUuid();
        userService.updateUser(userUuid, req);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "회원탈퇴", description = "로컬 계정은 비밀번호 재확인 후 탈퇴. 카카오 계정은 비번 없이 진행. 현재 세션 토큰 무효화.")
    @DeleteMapping("/me")
    public ResponseEntity<Void> deleteUser(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @RequestBody(required = false) @Valid UserDeleteRequest req
    ) {
        String userUuid = currentUserUuid();
        userService.deleteUser(userUuid, authorization, req);
        return ResponseEntity.noContent().build();
    }

    private String currentUserUuid() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        Object principal = auth.getPrincipal();
        if (principal instanceof UserDetails ud) {
            return ud.getUsername(); // JwtAuthFilter에서 username=userUuid로 세팅됨
        }
        return String.valueOf(principal);
    }

}
