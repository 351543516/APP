package com.xinghaogroup.health_app_server.repository.jpa;

import com.xinghaogroup.health_app_server.entity.User;
import com.xinghaogroup.health_app_server.repository.UserRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("userJpaRepository")
public interface UserJpaRepository extends UserRepository, JpaRepository<User, Long> {
    // 这里不需要额外方法，所有方法都继承自 UserRepository
}