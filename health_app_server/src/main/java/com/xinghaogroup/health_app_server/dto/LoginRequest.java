// src/main/java/com/xinghaogroup/health_app_server/dto/LoginRequest.java
package com.xinghaogroup.health_app_server.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String phone;
    private String password;
}