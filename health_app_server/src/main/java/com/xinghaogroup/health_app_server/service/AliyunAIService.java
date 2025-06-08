package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.utils.FileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.alibaba.fastjson2.JSONObject;
import com.xinghaogroup.health_app_server.config.HttpUtils;
import com.xinghaogroup.health_app_server.exception.AIException;
import com.xinghaogroup.health_app_server.utils.FileUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class AliyunAIService {
    private static final Logger log = LoggerFactory.getLogger(AliyunAIService.class);
    private final ExecutorService executor = Executors.newFixedThreadPool(5);

    @Autowired // 注入FileUtil实例
    private FileUtil fileUtil; // 声明实例变量

    // 修改此处，添加有效的配置键名
    @Value("${aliyun.ai.appCode}")
    private String appCode;

    @Value("${aliyun.ai.tongue-api-url}")
    private String tongueApiUrl;

    @Value("${aliyun.ai.face-api-url}")
    private String faceApiUrl;

    @Value("${aliyun.ai.constitution-api-url}")
    private String constitutionApiUrl;

    @Value("${aliyun.ai.timeout:30000}")
    private int timeout;

    // 舌诊分析（舌照+面照）
    public JSONObject analyzeTongue(String tongueImageUrl, String faceImageUrl) {
        validateImageUrl(tongueImageUrl, "舌诊图片URL不能为空");
        return executeRequest(tongueApiUrl, buildTongueRequestBody(tongueImageUrl, faceImageUrl));
    }

    // 面诊分析（仅面照）
    public JSONObject analyzeFace(String faceImageUrl) {
        validateImageUrl(faceImageUrl, "面诊图片URL不能为空");
        return executeRequest(faceApiUrl, buildFaceRequestBody(faceImageUrl));
    }

    // 体质分析（结合舌诊+面诊结果）
    public JSONObject analyzeConstitution(String tongueResult, String faceResult) {
        validateResult(tongueResult, "舌诊结果不能为空");
        validateResult(faceResult, "面诊结果不能为空");
        return executeRequest(constitutionApiUrl, buildConstitutionRequestBody(tongueResult, faceResult));
    }

    // 多模态分析（异步）
    public CompletableFuture<JSONObject> analyzeMultiModalAsync(String tongueImageUrl, String faceImageUrl) {
        return CompletableFuture.supplyAsync(() -> {
            JSONObject tongueResult = analyzeTongue(tongueImageUrl, faceImageUrl);
            JSONObject faceResult = analyzeFace(faceImageUrl);
            return analyzeConstitution(tongueResult.toString(), faceResult.toString());
        }, executor);
    }

    // 从本地文件进行舌诊分析
    public JSONObject analyzeTongueFromFile(String tongueImagePath, String faceImagePath) throws IOException {
        String tongueUrl = uploadToOss(tongueImagePath);
        String faceUrl = uploadToOss(faceImagePath);
        return analyzeTongue(tongueUrl, faceUrl);
    }

    // 构建舌诊请求体
    private JSONObject buildTongueRequestBody(String tongueImageUrl, String faceImageUrl) {
        JSONObject body = new JSONObject();
        body.put("scene", 1);
        body.put("tf_image", tongueImageUrl);
        if (StringUtils.hasText(faceImageUrl)) {
            body.put("ff_image", faceImageUrl);
        }
        return body;
    }

    // 构建面诊请求体
    private JSONObject buildFaceRequestBody(String faceImageUrl) {
        JSONObject body = new JSONObject();
        body.put("scene", 1);
        body.put("ff_image", faceImageUrl);
        return body;
    }

    // 构建体质分析请求体
    private JSONObject buildConstitutionRequestBody(String tongueResult, String faceResult) {
        JSONObject body = new JSONObject();
        body.put("tongue_result", tongueResult);
        body.put("face_result", faceResult);
        return body;
    }

    // 执行请求并处理响应（6个参数，包含 timeout）
    private JSONObject executeRequest(String apiUrl, JSONObject requestBody) {
        if (appCode == null) {
            log.error("appCode is null, cannot execute request.");
            throw new AIException("appCode is null, AI analysis request failed.");
        }
        try {
            Map<String, String> headers = new HashMap<>();
            headers.put("Authorization", "APPCODE " + appCode);
            headers.put("Content-Type", "application/json; charset=UTF-8");

            // 调用 HttpUtils.doPost（6个参数，匹配工具类）
            String response = HttpUtils.doPost(apiUrl, "", headers, null,
                    requestBody.toJSONString(), timeout);
            JSONObject result = JSONObject.parseObject(response);

            if (result == null || !"200".equals(result.getString("code"))) {
                log.error("AI service call failed: {}", response);
                throw new AIException("AI service returned an exception: " + result);
            }

            return result.getJSONObject("data");
        } catch (Exception e) {
            log.error("AI analysis request failed", e);
            throw new AIException("AI analysis request failed", e);
        }
    }

    // 图片上传到OSS（示例方法，需实现）
    private String uploadToOss(String filePath) throws IOException {
        return fileUtil.uploadToOss(filePath);
    }

    // 参数校验
    private void validateImageUrl(String url, String message) {
        if (!StringUtils.hasText(url)) {
            throw new IllegalArgumentException(message);
        }
    }

    private void validateResult(String result, String message) {
        if (!StringUtils.hasText(result)) {
            throw new IllegalArgumentException(message);
        }
    }
}