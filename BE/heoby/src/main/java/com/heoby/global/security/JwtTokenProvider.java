package com.heoby.global.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.time.Instant;
import java.util.Date;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class JwtTokenProvider {

    @Value("${jwt.secret}") private String secret;
    @Value("${jwt.access-ttl-seconds}") private long accessTtl;
    @Value("${jwt.refresh-ttl-seconds}") private long refreshTtl;

    private Key key() { return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8)); }

    public String createAccess(String sub, String role) {
        Instant now = Instant.now();
        String jti = java.util.UUID.randomUUID().toString();

        return Jwts.builder()
            .setSubject(sub)
                .setId(jti)
            .setIssuedAt(Date.from(now))
            .setExpiration(Date.from(now.plusSeconds(accessTtl)))
            .claim("role", role)
            .signWith(key(), SignatureAlgorithm.HS256)
            .compact();
    }

    public String createRefresh(String sub, String jti) {
        Instant now = Instant.now();
        return Jwts.builder()
            .setSubject(sub)
            .setId(jti)
            .setIssuedAt(Date.from(now))
            .setExpiration(Date.from(now.plusSeconds(refreshTtl)))
            .signWith(key(), SignatureAlgorithm.HS256)
            .compact();
    }

    public Claims parse(String token) {
        return Jwts.parserBuilder()
            .setSigningKey(key())
            .build()
            .parseClaimsJws(token)
            .getBody();
    }

    public long accessTtl() { return accessTtl; }
    public long refreshTtl() { return refreshTtl; }

}
