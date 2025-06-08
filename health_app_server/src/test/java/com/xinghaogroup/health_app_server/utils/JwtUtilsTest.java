// src/test/java/com/xinghaogroup/health_app_server/utils/JwtUtilsTest.java

package com.xinghaogroup.health_app_server.utils;

import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class JwtUtilsTest {

    private JwtUtils jwtUtils;

    @BeforeEach
    void setUp() {
        jwtUtils = new JwtUtils();

        // 使用反射设置私有字段
        ReflectionTestUtils.setField(jwtUtils, "rawSecret", "test-secret-key-1234567890-1234567890");
        ReflectionTestUtils.setField(jwtUtils, "expirationMillis", 3600000L); // 1小时

        // 手动调用初始化方法
        jwtUtils.init();
    }

    @Test
    void testGenerateAndParseToken() {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", 1L); // 使用Long类型
        claims.put("phone", "13800138000");
        claims.put("roles", List.of("USER"));

        String token = jwtUtils.generateToken(claims);
        assertNotNull(token);

        Claims parsedClaims = jwtUtils.parseToken(token);

        // 修复点1：正确处理数字类型转换
        Object userId = parsedClaims.get("userId");
        if (userId instanceof Integer) {
            assertEquals(1L, ((Integer) userId).longValue());
        } else if (userId instanceof Long) {
            assertEquals(1L, (Long) userId);
        } else {
            fail("userId should be either Integer or Long");
        }

        assertEquals("13800138000", parsedClaims.get("phone"));
        assertTrue(parsedClaims.getExpiration().after(new Date()));
    }

    @Test
    void testValidateToken() {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", 2L); // 使用Long类型

        String token = jwtUtils.generateToken(claims);
        assertTrue(jwtUtils.validateToken(token));
        assertFalse(jwtUtils.validateToken("invalid.token.here"));
    }
}