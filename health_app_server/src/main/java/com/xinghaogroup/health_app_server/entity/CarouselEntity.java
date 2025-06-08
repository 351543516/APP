package com.xinghaogroup.health_app_server.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Entity
@Table(name = "carousel")
@Data
public class CarouselEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String imageUrl;
    private String link;
    private Integer sort;
    private Integer status;

    @Column(name = "create_time")
    private Date createTime;
}