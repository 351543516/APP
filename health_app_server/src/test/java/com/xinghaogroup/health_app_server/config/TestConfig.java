package com.xinghaogroup.health_app_server.config;

import com.xinghaogroup.health_app_server.service.AliyunAIService;
import org.mockito.Mockito;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

@TestConfiguration
public class TestConfig {

    @Bean
    @Primary
    public AliyunAIService mockAliyunAIService() {
        return Mockito.mock(AliyunAIService.class);
    }
}