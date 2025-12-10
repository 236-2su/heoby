package com.heoby.user.service;

import com.heoby.global.common.entity.User;
import com.heoby.global.common.enums.Role;
import com.heoby.global.exception.CustomException;
import com.heoby.global.security.JwtTokenProvider;
import com.heoby.user.dto.request.UserDeleteRequest;
import com.heoby.user.dto.request.UserUpdateRequest;
import com.heoby.user.dto.response.UserResponse;
import com.heoby.user.repository.UserRepository;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService{
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final StringRedisTemplate redis;
    private final JwtTokenProvider jwt;

    private static final String RT = "auth:rt:";     // refresh 저장
    private static final String USED = "auth:rt:used:"; // 재사용 탐지
    private static final String BL_AT = "BL_AT:";              // by jti
    private static final String BL_AT_SHA256 = "BL_AT_SHA256:"; // fallback


    @Override
    public UserResponse getMe(String userUuid) {
        User user = userRepository.findById(userUuid)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "회원 정보를 찾을 수 없습니다."));

        return UserResponse.builder()
                .userUuid(user.getUserUuid())
                .userVillageId(user.getUserVillageId())
                .username(user.getUsername())
                .email(user.getEmail())
                .role(user.getRole())
                .build();
    }


    @Override
    public void updateUser(String userUuid, UserUpdateRequest req) {
        User user = userRepository.findById(userUuid)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "회원 정보를 찾을 수 없습니다."));

        // 변경 필드만 반영
        if (req.getUserVillageId() != null) {
            user.setUserVillageId(req.getUserVillageId());
        }
        if (req.getUsername() != null && !req.getUsername().isBlank()) {
            user.setUsername(req.getUsername());
        }

        userRepository.save(user);
    }

    @Override
    public void deleteUser(String userUuid, String accessToken, UserDeleteRequest req) {
        User user = userRepository.findById(userUuid)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "회원 정보를 찾을 수 없습니다."));

        boolean isSocial = user.getKakaoUserId() != null && !user.getKakaoUserId().isBlank();

        // 1) 로컬 계정이면 비밀번호 재확인
        if (!isSocial) {
            if (req == null || req.getPassword() == null || req.getPassword().isBlank()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "비밀번호가 필요합니다.");
            }
            if (!passwordEncoder.matches(req.getPassword(), user.getPassword())) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "비밀번호가 일치하지 않습니다.");
            }
        }

        // 2) 토큰 무효화 (현재 세션 기준)
        // 2-1) Refresh Token 폐기 (있으면)
        Optional.ofNullable(req)
                .map(UserDeleteRequest::getRefreshToken)
                .filter(rt -> !rt.isBlank())
                .ifPresent(this::invalidateRefreshToken);

        // 2-2) Access Token 블랙리스트 (있으면)
        Optional.ofNullable(accessToken)
                .filter(h -> h.startsWith("Bearer "))
                .map(h -> h.substring(7))
                .ifPresent(this::blacklistAccessToken);

        // 3) 실제 사용자 삭제 (하드 삭제)
        //    연관관계(CASCADE/ON DELETE) 확인 필요. 안전하게는 소프트 삭제가 권장되지만, 여기선 단순화.
        userRepository.delete(user);
    }

    private void invalidateRefreshToken(String refreshToken) {
        var claims = jwt.parse(refreshToken);
        String jti = claims.getId();
        // RT:{jti} 삭제 + USED:{jti} 등록 (재사용 방지)
        redis.delete(RT + jti);
        redis.opsForValue().set(USED + jti, "1", jwt.refreshTtl(), java.util.concurrent.TimeUnit.SECONDS);
    }

    private void blacklistAccessToken(String rawAt) {
        try {
            var aClaims = jwt.parse(rawAt);
            String aJti = aClaims.getId();
            long ttlSec = Math.max(1,
                    aClaims.getExpiration().toInstant().getEpochSecond() - Instant.now().getEpochSecond());

            if (aJti != null && !aJti.isBlank()) {
                redis.opsForValue().set(BL_AT + aJti, "1", ttlSec, java.util.concurrent.TimeUnit.SECONDS);
            } else {
                redis.opsForValue().set(BL_AT_SHA256 + sha256(rawAt), "1", ttlSec, java.util.concurrent.TimeUnit.SECONDS);
            }
        } catch (Exception ignore) {
            // 토큰 파싱 실패해도 탈퇴 자체는 진행
        }
    }

    private String sha256(String s) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] d = md.digest(s.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : d) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new IllegalStateException(e); }
    }


}
