package com.xinghaogroup.health_app_server.service.impl;


import com.xinghaogroup.health_app_server.dto.LoginResponse;
import com.xinghaogroup.health_app_server.dto.ResponseResult;
import com.xinghaogroup.health_app_server.dto.LoginRequest;
import com.xinghaogroup.health_app_server.dto.RegisterRequest;
import com.xinghaogroup.health_app_server.entity.User;
import com.xinghaogroup.health_app_server.repository.UserRepository;
import com.xinghaogroup.health_app_server.service.AuthService;
import com.xinghaogroup.health_app_server.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    @Autowired
    public AuthServiceImpl(
            @Qualifier("userJpaRepository") UserRepository userRepo,
            PasswordEncoder passwordEncoder,
            JwtUtils jwtUtils
    ) {
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtils = jwtUtils;
    }

    @Override
    public ResponseResult<String> register(RegisterRequest req) {
        if (userRepo.existsByPhone(req.getPhone())) {
            return ResponseResult.error("该手机号已注册");
        }

        User user = new User();
        user.setPhone(req.getPhone());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        userRepo.save(user);

        return ResponseResult.success("注册成功");
    }

    @Override
    public ResponseResult<LoginResponse> login(LoginRequest req) {
        Optional<User> userOpt = userRepo.findByPhone(req.getPhone());

        if (userOpt.isEmpty()) {
            return ResponseResult.error("用户不存在");
        }

        User user = userOpt.get();

        if (!passwordEncoder.matches(req.getPassword(), user.getPassword())) {
            return ResponseResult.error("密码错误");
        }

        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getId());
        claims.put("phone", user.getPhone());
        claims.put("roles", List.of("USER"));

        String token = jwtUtils.generateToken(claims);

        // 从JwtUtils直接获取秒数，避免计算错误
        int expiresInSeconds = jwtUtils.getExpirationSeconds();

        LoginResponse response = LoginResponse.builder()
                .token(token)
                .userId(user.getId())
                .phone(user.getPhone())
                .expiresIn(expiresInSeconds) // 直接使用int类型，匹配Builder的Integer参数
                .build();

        return ResponseResult.success(response);
    }
}