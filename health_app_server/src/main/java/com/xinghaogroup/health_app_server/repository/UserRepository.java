// src/main/java/com/xinghaogroup/health_app_server/repository/UserRepository.java

package com.xinghaogroup.health_app_server.repository;

import com.xinghaogroup.health_app_server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByPhone(String phone);
    Optional<User> findByPhone(String phone);
}