// src/main/java/com/xinghaogroup/health_app_server/service/impl/UserServiceImpl.java
package com.xinghaogroup.health_app_server.service.impl;

import com.xinghaogroup.health_app_server.entity.User;
import com.xinghaogroup.health_app_server.repository.mysql.UserMysqlRepository;
import com.xinghaogroup.health_app_server.service.UserService;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    private final UserMysqlRepository userRepository;

    public UserServiceImpl(UserMysqlRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User findByPhone(String phone) {
        return userRepository.findByPhone(phone);
    }
}