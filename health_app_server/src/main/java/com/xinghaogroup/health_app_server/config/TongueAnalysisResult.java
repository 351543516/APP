package com.xinghaogroup.health_app_server.config;

public class TongueAnalysisResult {
    private String tongueColor;
    private String tongueShape;

    public TongueAnalysisResult(String tongueColor, String tongueShape) {
        this.tongueColor = tongueColor;
        this.tongueShape = tongueShape;
    }

    public String getTongueColor() {
        return tongueColor;
    }

    public void setTongueColor(String tongueColor) {
        this.tongueColor = tongueColor;
    }

    public String getTongueShape() {
        return tongueShape;
    }

    public void setTongueShape(String tongueShape) {
        this.tongueShape = tongueShape;
    }
}