package com.xinghaogroup.health_app_server.service;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.profile.DefaultProfile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SmsService {
    private final IAcsClient client;

    // 从配置文件注入
    @Value("${aliyun.sms.region-id:cn-hangzhou}")
    private String regionId;
    @Value("${aliyun.sms.access-key-id}")
    private String accessKeyId;
    @Value("${aliyun.sms.access-key-secret}")
    private String accessKeySecret;
    @Value("${aliyun.sms.sign-name}")
    private String signName;
    @Value("${aliyun.sms.template-code}")
    private String templateCode;

    // 通过Spring初始化客户端
    public SmsService() {
        DefaultProfile profile = DefaultProfile.getProfile(
                regionId, accessKeyId, accessKeySecret
        );
        this.client = new DefaultAcsClient(profile);
    }

    // 发送验证码方法
    public boolean sendVerificationCode(String phoneNumber, String code) {
        SendSmsRequest request = new SendSmsRequest();
        request.setPhoneNumbers(phoneNumber);
        request.setSignName(signName);
        request.setTemplateCode(templateCode);
        request.setTemplateParam(String.format("{\"code\":\"%s\"}", code)); // 优化参数拼接

        try {
            SendSmsResponse response = client.getAcsResponse(request);
            if ("OK".equals(response.getCode())) {
                log.info("短信发送成功：phone={}, code={}", phoneNumber, code);
                return true;
            } else {
                log.error("短信发送失败：code={}, message={}",
                        response.getCode(), response.getMessage());
                return false;
            }
        } catch (ClientException e) {
            log.error("短信发送异常：{}", e.getMessage());
            return false;
        }
    }
}