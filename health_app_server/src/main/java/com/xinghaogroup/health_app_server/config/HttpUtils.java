package com.xinghaogroup.health_app_server.config;

import okhttp3.*;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

public class HttpUtils {
    /**
     * 发送HTTP POST请求（支持超时配置）
     *
     * @param url     请求URL
     * @param path    请求路径（可空）
     * @param headers 请求头（可空）
     * @param queries 请求参数（可空）
     * @param body    请求体（JSON格式）
     * @param timeout 超时时间（毫秒）
     * @return 响应字符串
     * @throws IOException 网络异常
     */
    public static String doPost(String url, String path, Map<String, String> headers,
                                Map<String, String> queries, String body, int timeout) throws IOException {
        // 配置OkHttpClient（支持超时）
        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(timeout, TimeUnit.MILLISECONDS)
                .readTimeout(timeout, TimeUnit.MILLISECONDS)
                .writeTimeout(timeout, TimeUnit.MILLISECONDS)
                .build();

        // 构建完整URL（包含path和queries）
        HttpUrl.Builder httpUrlBuilder = HttpUrl.parse(url).newBuilder();
        if (path != null) {
            httpUrlBuilder.addPathSegments(path);
        }
        if (queries != null) {
            for (Map.Entry<String, String> entry : queries.entrySet()) {
                httpUrlBuilder.addQueryParameter(entry.getKey(), entry.getValue());
            }
        }

        // 构建请求体（JSON格式）
        RequestBody requestBody = RequestBody.create(
                MediaType.parse("application/json; charset=UTF-8"),
                body
        );

        // 构建完整请求
        Request request = new Request.Builder()
                .url(httpUrlBuilder.build())
                .headers(Headers.of(headers))
                .post(requestBody)
                .build();

        // 发送请求并获取响应
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code: " + response);
            }
            return response.body().string();
        }
    }
}