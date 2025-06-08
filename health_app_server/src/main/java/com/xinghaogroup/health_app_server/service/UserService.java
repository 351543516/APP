// src/main/java/com/xinghaogroup/health_app_server/service/UserService.java
package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.entity.User;

public interface UserService {
    User findByPhone(String phone);
}