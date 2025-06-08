// src/main/java/com/xinghaogroup/health_app_server/service/AuthService.java

package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.dto.LoginRequest;
import com.xinghaogroup.health_app_server.dto.LoginResponse;
import com.xinghaogroup.health_app_server.dto.RegisterRequest;
import com.xinghaogroup.health_app_server.dto.ResponseResult;

public interface AuthService {
    ResponseResult<String> register(RegisterRequest request);
    ResponseResult<LoginResponse> login(LoginRequest request);
}