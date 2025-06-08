package com.xinghaogroup.health_app_server.controller;

import com.xinghaogroup.health_app_server.entity.CarouselEntity;
import com.xinghaogroup.health_app_server.service.CarouselService;
import com.xinghaogroup.health_app_server.utils.FileUtil;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/carousel")
public class CarouselController {
    private final CarouselService service;
    private final FileUtil fileUtil; // 注入FileUtil

    // 使用构造器注入
    public CarouselController(CarouselService service, FileUtil fileUtil) {
        this.service = service;
        this.fileUtil = fileUtil;
    }

    // 获取轮播图列表（供前端调用）
    @GetMapping("/list")
    public List<CarouselEntity> getCarouselList() {
        return service.getAllEnabled();
    }

    // 后端管理接口：新增轮播图（需权限控制，开发期暂不处理）
    @PostMapping("/add")
    public CarouselEntity addCarousel(@RequestBody CarouselEntity entity) {
        return service.addCarousel(entity);
    }

    // 测试OSS上传功能（仅开发阶段使用）
    @PostMapping("/test-oss-upload")
    public String testOssUpload(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return "请选择上传文件";
            }

            // 调用FileUtil上传文件到OSS
            String ossUrl = fileUtil.uploadToOss(file);

            // 返回上传结果
            return "OSS上传成功！URL: " + ossUrl;
        } catch (IOException e) {
            e.printStackTrace();
            return "上传失败: " + e.getMessage();
        }
    }
}