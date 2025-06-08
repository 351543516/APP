package com.xinghaogroup.health_app_server.service.impl;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.FieldValue;
import co.elastic.clients.elasticsearch._types.query_dsl.*;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import com.xinghaogroup.health_app_server.dto.SearchResult;
import com.xinghaogroup.health_app_server.dto.SearchResultItem;
import com.xinghaogroup.health_app_server.entity.SearchDocument;
import com.xinghaogroup.health_app_server.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SearchServiceImpl implements SearchService {

    private final ElasticsearchClient elasticsearchClient;

    @Autowired
    public SearchServiceImpl(ElasticsearchClient elasticsearchClient) {
        this.elasticsearchClient = elasticsearchClient;
    }

    @Override
    public SearchResult search(String keyword, List<String> types, int page, int pageSize) {
        // 构建多字段匹配查询（修正类型参数）
        var multiMatchQuery = MultiMatchQuery.of(m -> m
                .query(keyword)
                .fields("name^3", "description^2", "content")
                .type(TextQueryType.BestFields)  // 使用枚举类型
                .analyzer("ik_smart")
        )._toQuery();

        // 构建布尔查询（修正构建方式）
        var boolQuery = BoolQuery.of(b -> b
                .must(multiMatchQuery)
                .filter(f -> {
                    if (types != null && !types.isEmpty()) {
                        TermsQuery.Builder termsBuilder = new TermsQuery.Builder();
                        termsBuilder.field("type");
                        termsBuilder.terms(t -> t.value(types.stream()
                                .map(FieldValue::of)
                                .collect(Collectors.toList())));
                        return f.terms(termsBuilder.build());
                    }
                    return f;
                })
        )._toQuery();

        int from = (page - 1) * pageSize;

        try {
            SearchResponse<SearchDocument> response = elasticsearchClient.search(s -> s
                            .index("search_document")
                            .query(boolQuery)
                            .from(from)
                            .size(pageSize),
                    SearchDocument.class
            );

            // 处理得分类型转换（添加空值保护）
            List<SearchResultItem> resultItems = response.hits().hits().stream()
                    .map(hit -> {
                        SearchDocument doc = hit.source();
                        Float score = hit.score() != null ? hit.score().floatValue() : 0.0f;

                        return SearchResultItem.builder()
                                .id(doc.getId())
                                .title(doc.getName())
                                .type(doc.getType())
                                .score(score)
                                .build();
                    })
                    .collect(Collectors.toList());

            long totalHits = response.hits().total().value();

            return SearchResult.builder()
                    .total((int) totalHits)
                    .page(page)
                    .pageSize(pageSize)
                    .items(resultItems)
                    .build();

        } catch (IOException e) {
            throw new RuntimeException("Elasticsearch查询失败", e);
        }
    }
}