package com.xinghaogroup.health_app_server.controller;

import com.xinghaogroup.health_app_server.dto.ResponseResult;
import com.xinghaogroup.health_app_server.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/search")
public class SearchController {

    @Autowired
    private SearchService searchService; // 确保SearchService已正确注入

    @GetMapping
    public ResponseResult search(
            @RequestParam String keyword,
            @RequestParam(required = false) List<String> types,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        return ResponseResult.success(
                searchService.search(keyword, types, page, pageSize) // 确保方法参数匹配
        );
    }
}