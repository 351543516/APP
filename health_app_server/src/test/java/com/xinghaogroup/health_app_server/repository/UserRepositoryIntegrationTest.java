package com.xinghaogroup.health_app_server.repository;

import com.xinghaogroup.health_app_server.HealthAppServerApplication;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

// 所有测试类统一使用此模板
@SpringBootTest(classes = HealthAppServerApplication.class)
@ActiveProfiles("test")
public class UserRepositoryIntegrationTest {
    // 测试方法
}