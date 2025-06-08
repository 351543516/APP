package com.xinghaogroup.health_app_server.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Data
@Entity
@Table(name = "user")  // 同步修改的表名
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false, unique = true, length = 20)
    private String phone;
    @Column(nullable = false, length = 100)
    private String password;
    @Column(nullable = false, length = 50)
    private String name;
    private String gender;
    private Integer age;
    private Double height;
    private Double weight;
    private String allergies;
    private String email;

    @Column(name = "status")
    private Integer status;

    @Column(name = "chronic_diseases")
    private String chronicDiseases;

    @Column(name = "constitution_type")
    private String constitutionType;

    @Column(name = "create_time")
    private Date createTime;
}