// src/main/java/com/xinghaogroup/health_app_server/dto/LoginResponse.java

package com.xinghaogroup.health_app_server.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private Long userId;
    private String phone;
    private Integer expiresIn;
}