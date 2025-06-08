package com.xinghaogroup.health_app_server.service;

import lombok.Data;

@Data
public class AnalysisResult {
    private String constitution;      // 体质类型
    private String tongueColor;       // 舌质颜色
    private String coatingColor;      // 舌苔颜色
    private String suggestions;       // 健康建议
}