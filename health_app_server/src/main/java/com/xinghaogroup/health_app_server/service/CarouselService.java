// src/main/java/com/xinghaogroup/health_app_server/service/CarouselService.java
package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.entity.CarouselEntity;
import com.xinghaogroup.health_app_server.repository.jpa.CarouselRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class CarouselService {
    private final CarouselRepository repository;

    public CarouselService(CarouselRepository repository) {
        this.repository = repository;
    }

    // 获取所有启用的轮播图
    public List<CarouselEntity> getAllEnabled() {
        return repository.findAllByStatus(1); // 建议替换为常量
    }

    // 新增轮播图
    public CarouselEntity addCarousel(CarouselEntity entity) {
        return repository.save(entity);
    }
}