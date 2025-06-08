package com.xinghaogroup.health_app_server.dto;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class SearchResult {
    private int total;
    private int page;
    private int pageSize;
    private List<SearchResultItem> items;
}