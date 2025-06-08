package com.xinghaogroup.health_app_server.config;

import java.util.ArrayList;
import java.util.List;

public class AIDiagnosisRecordRepository {
    private List<String> diagnosisRecords;

    public AIDiagnosisRecordRepository() {
        this.diagnosisRecords = new ArrayList<>();
    }

    // 添加诊断记录
    public void addDiagnosisRecord(String record) {
        diagnosisRecords.add(record);
    }

    // 获取所有诊断记录
    public List<String> getAllDiagnosisRecords() {
        return diagnosisRecords;
    }
}