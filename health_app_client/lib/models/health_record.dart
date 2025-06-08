// lib/models/health_record.dart
class HealthRecord {
  final int userId;
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  // 其他健康数据字段...

  HealthRecord({
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      userId: json['userId'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      height: json['height']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble() ?? 0.0,
    );
  }
}