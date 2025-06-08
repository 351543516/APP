package com.xinghaogroup.health_app_server.utils;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.model.PutObjectRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;
import org.springframework.util.StringUtils;

@Component
public class FileUtil {

    @Value("${aliyun.oss.endpoint}")
    private String ENDPOINT;
    @Value("${aliyun.oss.access-key-id}")
    private String ACCESS_KEY_ID;
    @Value("${aliyun.oss.access-key-secret}")
    private String ACCESS_KEY_SECRET;
    @Value("${aliyun.oss.bucket-name}")
    private String BUCKET_NAME;
    @Value("${aliyun.oss.url-prefix}")
    private String OSS_URL;

    // 上传本地文件到OSS
    public String uploadToOss(String filePath) throws IOException {
        if (!StringUtils.hasText(filePath)) {
            throw new IllegalArgumentException("文件路径不能为空");
        }
        OSS ossClient = null;
        try {
            ossClient = new OSSClientBuilder().build(ENDPOINT, ACCESS_KEY_ID, ACCESS_KEY_SECRET);
            String fileName = generateUniqueFileName(filePath);
            ossClient.putObject(new PutObjectRequest(BUCKET_NAME, fileName, new java.io.File(filePath)));
            return OSS_URL + fileName;
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
    }

    // 上传MultipartFile到OSS
    public String uploadToOss(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("上传文件不能为空");
        }
        String originalFileName = file.getOriginalFilename();
        if (!StringUtils.hasText(originalFileName)) {
            throw new IllegalArgumentException("文件名为空");
        }
        OSS ossClient = null;
        InputStream inputStream = null;
        try {
            ossClient = new OSSClientBuilder().build(ENDPOINT, ACCESS_KEY_ID, ACCESS_KEY_SECRET);
            inputStream = file.getInputStream();
            String fileName = generateUniqueFileName(originalFileName);
            ossClient.putObject(new PutObjectRequest(BUCKET_NAME, fileName, inputStream));
            return OSS_URL + fileName;
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
    }

    // 生成唯一文件名
    private String generateUniqueFileName(String originalFileName) {
        String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
        return UUID.randomUUID().toString().replace("-", "") + ext;
    }
}