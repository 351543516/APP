package com.xinghaogroup.health_app_server.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.Map;

@Component
public class JwtUtils {

    @Value("${JWT_SECRET}")
    private String rawSecret;

    @Value("${jwt.expiration}")
    private Long expirationMillis;

    private SecretKey signingKey;

    @PostConstruct
    void init() {
        this.signingKey = Keys.hmacShaKeyFor(rawSecret.getBytes());
    }

    public int getExpirationSeconds() {
        return (int) (expirationMillis / 1000);
    }

    public String generateToken(Map<String, Object> claims) {
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationMillis))
                .signWith(signingKey) // 修复1：移除SignatureAlgorithm参数
                .compact();
    }

    public Claims parseToken(String token) {
        // 修复2：使用新版API - parser()代替parserBuilder()
        return Jwts.parser()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean validateToken(String token) {
        try {
            // 修复3：使用新版API - parser()代替parserBuilder()
            Jwts.parser()
                    .setSigningKey(signingKey)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}