package com.xinghaogroup.health_app_server.service;

// 添加缺少的导入语句
import org.springframework.web.multipart.MultipartFile;
import com.xinghaogroup.health_app_server.config.TongueAnalysisResult;

public interface AIService {
    TongueAnalysisResult analyzeTongue(MultipartFile image, String shootEnv, String shootAngle);
}