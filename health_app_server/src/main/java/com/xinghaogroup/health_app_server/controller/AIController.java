package com.xinghaogroup.health_app_server.controller;
import com.alibaba.fastjson2.JSONObject;
import com.xinghaogroup.health_app_server.service.AliyunAIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ai")
public class AIController {
    @Autowired
    private AliyunAIService aiService;

    @PostMapping("/tongue-analysis")
    public String analyzeTongue(@RequestParam("tongueImageUrl") String tongueImageUrl,
                                @RequestParam("faceImageUrl") String faceImageUrl) {
        try {
            JSONObject result = aiService.analyzeTongue(tongueImageUrl, faceImageUrl);
            return result.toJSONString(); // 转为字符串返回
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }
}