// src/main/java/com/xinghaogroup/health_app_server/repository/CarouselRepository.java
package com.xinghaogroup.health_app_server.repository.jpa;

import com.xinghaogroup.health_app_server.entity.CarouselEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CarouselRepository extends JpaRepository<CarouselEntity, Integer> {
    // 按状态查询轮播图
    List<CarouselEntity> findAllByStatus(Integer status);
}