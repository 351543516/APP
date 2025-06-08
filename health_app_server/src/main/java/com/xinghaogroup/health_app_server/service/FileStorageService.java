package com.xinghaogroup.health_app_server.service;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class FileStorageService {
    // 保存文件
    public void saveFile(String filePath, String content) throws IOException {
        File file = new File(filePath);
        try (FileWriter writer = new FileWriter(file)) {
            writer.write(content);
        }
    }
}