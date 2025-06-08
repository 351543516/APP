package com.xinghaogroup.health_app_server.client;

import okhttp3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class AliyunAIClient {

    private final OkHttpClient httpClient;
    private final String tongueApiUrl;
    private final String faceApiUrl;
    private final String constitutionApiUrl;

    @Autowired
    public AliyunAIClient(
            OkHttpClient httpClient,
            @Value("${aliyun.ai.tongue-api-url}") String tongueApiUrl,
            @Value("${aliyun.ai.face-api-url}") String faceApiUrl,
            @Value("${aliyun.ai.constitution-api-url}") String constitutionApiUrl
    ) {
        this.httpClient = httpClient;
        this.tongueApiUrl = tongueApiUrl;
        this.faceApiUrl = faceApiUrl;
        this.constitutionApiUrl = constitutionApiUrl;
    }

    public String analyzeTongue(String imageUrl) throws IOException {
        String requestBody = "{\"image_url\": \"" + imageUrl + "\"}";
        return executePostRequest(tongueApiUrl, requestBody);
    }

    public String analyzeFace(String imageUrl) throws IOException {
        String requestBody = "{\"image_url\": \"" + imageUrl + "\"}";
        return executePostRequest(faceApiUrl, requestBody);
    }

    public String analyzeConstitution(String imageUrl) throws IOException {
        String requestBody = "{\"image_url\": \"" + imageUrl + "\"}";
        return executePostRequest(constitutionApiUrl, requestBody);
    }

    private String executePostRequest(String url, String requestBody) throws IOException {
        RequestBody body = RequestBody.create(requestBody, MediaType.get("application/json"));
        Request request = new Request.Builder()
                .url(url)
                .post(body)
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("API 请求失败: " + response);
            }
            return response.body().string();
        }
    }
}