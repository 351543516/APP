// src/main/java/com/xinghaogroup/health_app_server/repository/mysql/UserMysqlRepository.java
package com.xinghaogroup.health_app_server.repository.mysql;

import com.xinghaogroup.health_app_server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserMysqlRepository extends JpaRepository<User, Long> {
    User findByPhone(String phone);
}