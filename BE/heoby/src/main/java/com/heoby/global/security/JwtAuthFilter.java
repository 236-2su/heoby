package com.heoby.global.security;

import com.heoby.user.repository.UserRepository;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private static final String BL_AT = "BL_AT:";
    private static final String BL_AT_SHA256 = "BL_AT_SHA256:";

    private final JwtTokenProvider jwt;
    private final UserRepository userRepository;
    private final StringRedisTemplate redis;

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain)
        throws ServletException, IOException {
        String header = req.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            try {
                Claims c = jwt.parse(token);

                String jti = c.getId();
                boolean blacklisted = (jti != null && !jti.isBlank())
                        ? Boolean.TRUE.equals(redis.hasKey(BL_AT + jti))
                        : Boolean.TRUE.equals(redis.hasKey(BL_AT_SHA256 + sha256(token)));

                if (blacklisted) {
                    write401(res, "TOKEN_BLACKLISTED", "로그아웃된 토큰입니다.");
                    return;
                }

                String userUuid = c.getSubject();
                String role = String.valueOf(c.get("role"));

                UserDetails principal = User.withUsername(userUuid)
                    .password("N/A").roles(role).build();
                var auth = new UsernamePasswordAuthenticationToken(
                    principal, null, principal.getAuthorities());
                auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(req));
                SecurityContextHolder.getContext().setAuthentication(auth);
            } catch (io.jsonwebtoken.ExpiredJwtException e) {
                write401(res, "TOKEN_EXPIRED", "토큰이 만료되었습니다.");
                return;
            } catch (io.jsonwebtoken.JwtException e) { // 서명오류/포맷오류 등
                write401(res, "TOKEN_INVALID", "유효하지 않은 토큰입니다.");
                return;
            } catch (Exception e) {
                write401(res, "AUTH_ERROR", "인증 처리 중 오류가 발생했습니다.");
                return;
            }
        }
        chain.doFilter(req, res);
    }

    private void write401(HttpServletResponse res, String code, String msg) throws IOException {
        res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        res.setContentType("application/json;charset=UTF-8");
        res.getWriter().write("{\"error\":\"" + code + "\",\"message\":\"" + msg + "\"}");
    }

    private String sha256(String s) {
        try {
            var md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] d = md.digest(s.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            var sb = new StringBuilder();
            for (byte b : d) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new IllegalStateException(e); }
    }

}
