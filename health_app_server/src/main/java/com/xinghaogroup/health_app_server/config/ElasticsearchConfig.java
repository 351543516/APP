package com.xinghaogroup.health_app_server.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.ElasticsearchTransport;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.elasticsearch.client.RestClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Collections;
import java.util.List;

@Configuration
public class ElasticsearchConfig {

    @Value("${spring.elasticsearch.uris:#{'http://localhost:9200'}}") // 默认值
    private List<String> uris;

    @Value("${spring.elasticsearch.username:}") // 默认为空
    private String username;

    @Value("${spring.elasticsearch.password:}") // 默认为空
    private String password;

    @Bean
    public RestClient restClient() {
        // 如果没有配置任何 URI，使用默认值
        if (uris == null || uris.isEmpty()) {
            uris = Collections.singletonList("http://localhost:9200");
        }

        // 创建 HttpHost 数组
        HttpHost[] httpHosts = uris.stream()
                .map(uri -> {
                    String[] parts = uri.split(":");
                    String scheme = parts[0];
                    String host = parts[1].substring(2); // 去除 "//"
                    int port = Integer.parseInt(parts[2]);
                    return new HttpHost(host, port, scheme);
                })
                .toArray(HttpHost[]::new);

        // 配置认证
        final CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        if (username != null && !username.isEmpty() && password != null && !password.isEmpty()) {
            credentialsProvider.setCredentials(AuthScope.ANY,
                    new UsernamePasswordCredentials(username, password));
        }

        // 创建 RestClient
        return RestClient.builder(httpHosts)
                .setHttpClientConfigCallback(httpClientBuilder -> {
                    httpClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
                    return httpClientBuilder;
                })
                .build();
    }

    @Bean
    public ElasticsearchTransport elasticsearchTransport(RestClient restClient) {
        return new RestClientTransport(restClient, new JacksonJsonpMapper());
    }

    @Bean
    public ElasticsearchClient elasticsearchClient(ElasticsearchTransport transport) {
        return new ElasticsearchClient(transport);
    }
}