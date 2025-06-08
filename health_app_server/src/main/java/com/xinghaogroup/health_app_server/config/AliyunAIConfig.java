package com.xinghaogroup.health_app_server.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import okhttp3.OkHttpClient;
import okhttp3.Request;

@Configuration
public class AliyunAIConfig {

    @Value("${aliyun.ai.app-code}")
    private String appCode;

    @Value("${aliyun.ai.timeout:5000}")
    private long timeout;

    @Bean
    public OkHttpClient aiHttpClient() {
        return new OkHttpClient.Builder()
                .connectTimeout(timeout, java.util.concurrent.TimeUnit.MILLISECONDS)
                .readTimeout(timeout, java.util.concurrent.TimeUnit.MILLISECONDS)
                .addInterceptor(chain -> {
                    Request originalRequest = chain.request();
                    Request newRequest = originalRequest.newBuilder()
                            .addHeader("Authorization", "APPCODE " + appCode)
                            .build();
                    return chain.proceed(newRequest);
                })
                .build();
    }
}