package com.xinghaogroup.health_app_server.dto;

import lombok.Data;
import jakarta.validation.constraints.NotEmpty; // 正确包路径

@Data
public class RegisterRequest {
    @NotEmpty(message = "手机号不能为空")
    private String phone;

    @NotEmpty(message = "密码不能为空")
    private String password;

    @NotEmpty(message = "用户名不能为空")
    private String username;
}