package com.xinghaogroup.health_app_server.exception;

public class AIException extends RuntimeException {
    public AIException(String message) {
        super(message);
    }
    public AIException(String message, Throwable cause) {
        super(message, cause);
    }
}