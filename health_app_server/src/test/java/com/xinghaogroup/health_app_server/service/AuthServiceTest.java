package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.dto.LoginRequest;
import com.xinghaogroup.health_app_server.dto.LoginResponse;
import com.xinghaogroup.health_app_server.dto.RegisterRequest;
import com.xinghaogroup.health_app_server.dto.ResponseResult;
import com.xinghaogroup.health_app_server.entity.User;
import com.xinghaogroup.health_app_server.repository.UserRepository;
import com.xinghaogroup.health_app_server.service.impl.AuthServiceImpl;
import com.xinghaogroup.health_app_server.utils.JwtUtils;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class AuthServiceTest {

    @InjectMocks
    private AuthServiceImpl authService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtUtils jwtUtils;

    @Test
    public void registerAndLogin() {
        // 注册阶段
        when(userRepository.existsByPhone("13800138000")).thenReturn(false);
        when(passwordEncoder.encode("StrongPass@123")).thenReturn("encoded_password");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        RegisterRequest registerRequest = new RegisterRequest();
        registerRequest.setPhone("13800138000");
        registerRequest.setPassword("StrongPass@123");

        ResponseResult<?> registerResult = authService.register(registerRequest);
        assertTrue(registerResult.isSuccess());

        // 登录阶段
        User mockUser = new User();
        mockUser.setId(1L);
        mockUser.setPhone("13800138000");
        mockUser.setPassword("encoded_password");

        when(userRepository.findByPhone("13800138000")).thenReturn(Optional.of(mockUser));
        when(passwordEncoder.matches("StrongPass@123", "encoded_password")).thenReturn(true);
        when(jwtUtils.generateToken(any())).thenReturn("mocked_token");

        LoginRequest loginRequest = new LoginRequest();
        loginRequest.setPhone("13800138000");
        loginRequest.setPassword("StrongPass@123");

        ResponseResult<LoginResponse> result = authService.login(loginRequest);
        assertTrue(result.isSuccess());

        LoginResponse loginResponse = result.getData();
        assertNotNull(loginResponse);
        assertEquals("mocked_token", loginResponse.getToken());
        assertEquals(1L, loginResponse.getUserId());
        assertEquals("13800138000", loginResponse.getPhone());
    }
}