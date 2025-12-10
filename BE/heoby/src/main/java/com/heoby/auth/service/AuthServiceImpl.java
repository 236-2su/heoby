package com.heoby.auth.service;

import com.heoby.auth.dto.request.LoginRequest;
import com.heoby.auth.dto.request.RefreshRequest;
import com.heoby.auth.dto.request.SignupRequest;
import com.heoby.auth.dto.response.LoginResponse;
import com.heoby.auth.dto.response.TokenResponse;
import com.heoby.auth.dto.response.UserDto;
import com.heoby.global.common.entity.User;
import com.heoby.global.security.JwtTokenProvider;
import com.heoby.user.repository.UserRepository;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class AuthServiceImpl implements AuthService{
    private final UserRepository users;
    private final PasswordEncoder encoder;
    private final JwtTokenProvider jwt;
    private final StringRedisTemplate redis;

    private static final String RT = "auth:rt:";     // refresh 저장
    private static final String USED = "auth:rt:used:"; // 재사용 탐지
    private static final String BL_AT = "BL_AT:";              // by jti
    private static final String BL_AT_SHA256 = "BL_AT_SHA256:"; // fallback

    @Override
    public void signup(SignupRequest req) {
        if (users.existsByEmail(req.email())) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");
        }

        User u = User.builder()
            .userUuid(UUID.randomUUID().toString())
            .email(req.email())
            .password(encoder.encode(req.password()))
            .username(req.username())
            .role(req.role())
            .userVillageId(req.villageId()) // 그대로 세팅 (null 가능)
            .build();
        users.save(u);
    }

    @Override
    public LoginResponse login(LoginRequest req) {
        User u = users.findByEmail(req.email())
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));
        if (!encoder.matches(req.password(), u.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 올바르지 않습니다.");
        }
        String jti = UUID.randomUUID().toString();
        String access = jwt.createAccess(u.getUserUuid(), u.getRole().name());
        String refresh = jwt.createRefresh(u.getUserUuid(), jti);
        // Redis 저장 (유효성 검증용)
        redis.opsForValue().set(RT + jti, u.getUserUuid(), jwt.refreshTtl(), TimeUnit.SECONDS);

        return new LoginResponse(access, jwt.accessTtl(), refresh, jwt.refreshTtl(), UserDto.from(u));
    }

    @Override
    public TokenResponse refresh(RefreshRequest req) {
        var claims = jwt.parse(req.refreshToken());
        String userUuid = claims.getSubject();
        String jti = claims.getId();

        // 재사용 탐지
        Boolean first = redis.opsForValue().setIfAbsent(USED + jti, "1", jwt.refreshTtl(), TimeUnit.DAYS);
        if (Boolean.FALSE.equals(first)) throw new IllegalStateException("REFRESH_REUSED_DETECTED");

        // 유효성 확인
        String v = redis.opsForValue().get(RT + jti);
        if (v == null || !v.equals(userUuid)) throw new IllegalStateException("REFRESH_REVOKED_OR_EXPIRED");

        // 로테이션
        redis.delete(RT + jti);
        String newJti = UUID.randomUUID().toString();
        String access = jwt.createAccess(userUuid,
            users.findById(userUuid).orElseThrow().getRole().name());
        String refresh = jwt.createRefresh(userUuid, newJti);
        redis.opsForValue().set(RT + newJti, userUuid, jwt.refreshTtl(), TimeUnit.SECONDS);

        return new TokenResponse(access, jwt.accessTtl(), refresh, jwt.refreshTtl(), userUuid);
    }

    @Override
    public void logout(String accessToken, RefreshRequest req) {
        var claims = jwt.parse(req.refreshToken());
        String jti = claims.getId();
        redis.delete(RT + jti);
        redis.opsForValue().set(USED + jti, "1", 30, TimeUnit.DAYS);

        String rawAt = stripBearer(accessToken);
        try {
            var aClaims = jwt.parse(rawAt);
            String aJti = aClaims.getId();
            long ttlSec = Math.max(1,
                    aClaims.getExpiration().toInstant().getEpochSecond()
                            - java.time.Instant.now().getEpochSecond());

            if (aJti != null && !aJti.isBlank()) {
                redis.opsForValue().set(BL_AT + aJti, "1", ttlSec, TimeUnit.SECONDS);
            } else {
                // 혹시 과거 발급분 등으로 AT에 jti가 없다면 해시 키로 차선 처리
                redis.opsForValue().set(BL_AT_SHA256 + sha256(rawAt), "1", ttlSec, TimeUnit.SECONDS);
            }
        } catch (Exception ignore) {
            // AT 파싱 실패 시엔 굳이 블랙리스트 등록 못해도 RT 차단이 되어 있으니 그냥 넘어가도 됨
        }
    }

    private String stripBearer(String token) {
        return token != null && token.startsWith("Bearer ") ? token.substring(7) : token;
    }

    private String sha256(String s) {
        try {
            var md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(s.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            var sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }

}
