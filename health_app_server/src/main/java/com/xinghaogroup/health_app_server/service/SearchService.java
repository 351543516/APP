package com.xinghaogroup.health_app_server.service;

import com.xinghaogroup.health_app_server.dto.SearchResult;

import java.util.List;

public interface SearchService {
    SearchResult search(String keyword, List<String> types, int page, int pageSize);
}