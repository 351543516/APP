// src/main/java/com/xinghaogroup/health_app_server/dto/ResponseResult.java

package com.xinghaogroup.health_app_server.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResponseResult<T> {
    private boolean success;
    private String message;
    private T data;

    // 成功响应快捷方法
    public static <T> ResponseResult<T> success(T data) {
        return new ResponseResult<>(true, "操作成功", data);
    }

    // 成功响应快捷方法 (无数据)
    public static ResponseResult<Void> success() {
        return new ResponseResult<>(true, "操作成功", null);
    }

    // 错误响应快捷方法
    public static <T> ResponseResult<T> error(String message) {
        return new ResponseResult<>(false, message, null);
    }
}