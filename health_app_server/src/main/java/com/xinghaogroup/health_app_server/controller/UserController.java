// src/main/java/com/xinghaogroup/health_app_server/controller/UserController.java

package com.xinghaogroup.health_app_server.controller;

import com.xinghaogroup.health_app_server.common.Result;
import com.xinghaogroup.health_app_server.dto.LoginRequest;
import com.xinghaogroup.health_app_server.dto.LoginResponse;
import com.xinghaogroup.health_app_server.entity.User;
import com.xinghaogroup.health_app_server.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("/login")
    public ResponseEntity<Result<LoginResponse>> login(@RequestBody LoginRequest request) {
        try {
            log.info("登录请求 - 手机号: {}", request.getPhone());

            // 1. 根据手机号查询用户
            User user = userService.findByPhone(request.getPhone());
            if (user == null) {
                log.warn("用户不存在: {}", request.getPhone());
                return ResponseEntity.status(401).body(Result.unauthorized("用户不存在"));
            }

            // 2. 检查账号状态
            // 确保User实体类有status字段
            if (user.getStatus() != 1) {
                log.warn("用户状态异常: {}, 状态: {}", request.getPhone(), user.getStatus());
                return ResponseEntity.status(401).body(Result.unauthorized("账号已被禁用"));
            }

            // 3. 验证密码（确保User实体类有password字段）
            boolean valid = passwordEncoder.matches(request.getPassword(), user.getPassword());
            if (!valid) {
                log.warn("密码验证失败: {}", request.getPhone());
                return ResponseEntity.status(401).body(Result.unauthorized("密码错误"));
            }

            // 4. 返回成功响应
            LoginResponse response = LoginResponse.builder()
                    .token("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
                    .userId(user.getId())
                    .phone(user.getPhone())
                    .expiresIn(3600)
                    .build();

            log.info("用户登录成功: {}", request.getPhone());
            return ResponseEntity.ok(Result.success(response));

        } catch (Exception e) {
            // 捕获所有未处理异常并记录详细错误信息
            log.error("登录处理失败 - 手机号: {}", request.getPhone(), e);
            return ResponseEntity.status(500).body(Result.error("服务器内部错误"));
        }
    }
}