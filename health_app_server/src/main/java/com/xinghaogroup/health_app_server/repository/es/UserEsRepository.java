package com.xinghaogroup.health_app_server.repository.es;

import com.xinghaogroup.health_app_server.entity.User;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import java.util.Optional;

public interface UserEsRepository extends ElasticsearchRepository<User, Long> {

    boolean existsByPhone(String phone);
    Optional<User> findByPhone(String phone);
}