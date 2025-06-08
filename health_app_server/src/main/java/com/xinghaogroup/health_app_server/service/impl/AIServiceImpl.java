package com.xinghaogroup.health_app_server.service.impl;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
public class AIServiceImpl {
    private final String host = "https://ali-market-tongue-detect-v2.macrocura.com";
    private final String path = "/diagnose/face-tongue/report/";
    private final String appCode = "3bf923e013d1436b92a30e491286643a"; // 替换为你的AppCode

    public String analyzeTongue(String tongueImageUrl, String faceImageUrl) {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(host + path);

        // 设置请求头
        httpPost.setHeader("Authorization", "APPCODE " + appCode);
        httpPost.setHeader("Content-Type", "application/json; charset=UTF-8");

        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("scene", 1); // 场景1：获取问诊问题
        requestBody.put("tf_image", tongueImageUrl); // 舌照URL
        requestBody.put("ff_image", faceImageUrl); // 面照URL

        try {
            httpPost.setEntity(new StringEntity(requestBody.toString(), "UTF-8"));
            CloseableHttpResponse response = httpClient.execute(httpPost);
            HttpEntity entity = response.getEntity();

            if (entity != null) {
                String result = EntityUtils.toString(entity);
                log.info("AI舌诊响应：{}", result);
                return result;
            }
            return null;
        } catch (IOException e) {
            log.error("AI舌诊调用失败：{}", e.getMessage());
            return null;
        } finally {
            try {
                httpClient.close();
            } catch (IOException e) {
                log.error("关闭HTTP客户端失败", e);
            }
        }
    }
}