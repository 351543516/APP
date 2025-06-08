package com.xinghaogroup.health_app_server.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
@RequestMapping("/api") // 与 context-path 一致
public class TestController {

    @GetMapping("/test") // 完整路径：/api/test
    public String testAPI() {
        return "API is working!";
    }
}
