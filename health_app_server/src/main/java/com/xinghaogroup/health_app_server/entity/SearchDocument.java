package com.xinghaogroup.health_app_server.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Data
@Document(indexName = "search_documents") // 索引名
public class SearchDocument {
    @Id
    private String id;
    @Field(type = FieldType.Text, analyzer = "ik_max_word") // 中文分词器
    private String name;
    @Field(type = FieldType.Text, analyzer = "ik_max_word")
    private String description;
    @Field(type = FieldType.Text, analyzer = "ik_max_word")
    private String content;
    private String type; // 内容类型（如article/video）
}