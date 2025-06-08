package com.xinghaogroup.health_app_server.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SearchResultItem {
    private String id;
    private String title;
    private String type;
    private double score; // 搜索得分
}
