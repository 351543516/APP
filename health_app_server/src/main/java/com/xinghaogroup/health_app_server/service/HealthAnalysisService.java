package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.client.AliyunAIClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class HealthAnalysisService {

    private final AliyunAIClient aiClient;

    @Autowired
    public HealthAnalysisService(AliyunAIClient aiClient) {
        this.aiClient = aiClient;
    }

    public String analyzeTongue(String imageUrl) {
        try {
            return aiClient.analyzeTongue(imageUrl);
        } catch (IOException e) {
            e.printStackTrace();
            return "分析失败: " + e.getMessage();
        }
    }

    public String analyzeFace(String imageUrl) {
        try {
            return aiClient.analyzeFace(imageUrl);
        } catch (IOException e) {
            e.printStackTrace();
            return "分析失败: " + e.getMessage();
        }
    }
}