// src/main/java/com/xinghaogroup/health_app_server/controller/AuthController.java
package com.xinghaogroup.health_app_server.controller;

import com.xinghaogroup.health_app_server.dto.ResponseResult;
import com.xinghaogroup.health_app_server.dto.RegisterRequest;
import com.xinghaogroup.health_app_server.dto.LoginRequest;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.xinghaogroup.health_app_server.service.AuthService;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseResult register(@RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public ResponseResult login(@RequestBody LoginRequest request) {
        return authService.login(request);
    }
}