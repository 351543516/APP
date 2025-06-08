// src/main/java/com/xinghaogroup/health_app_server/exception/GlobalExceptionHandler.java
package com.xinghaogroup.health_app_server.exception;

import com.xinghaogroup.health_app_server.common.Result;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Result<?>> handleAllExceptions(Exception ex, WebRequest request) {
        Result<String> result = Result.error("服务器内部错误: " + ex.getMessage());
        return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Result<?>> handleIllegalArgumentException(IllegalArgumentException ex, WebRequest request) {
        Result<String> result = Result.error("参数错误: " + ex.getMessage());
        return new ResponseEntity<>(result, HttpStatus.BAD_REQUEST);
    }
}