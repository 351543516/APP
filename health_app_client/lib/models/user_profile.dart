// lib/models/user_profile.dart
class UserProfile {
  final int userId;
  final String username;
  final String avatarUrl;
  final String memberLevel; // 普通会员/银卡会员/金卡会员/钻石会员
  final int points; // 积分
  final String? healthRecord; // 健康档案ID或数据（根据后端设计）

  UserProfile({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.memberLevel,
    required this.points,
    this.healthRecord,
  });

  // 从JSON解析
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      username: json['username'],
      avatarUrl: json['avatarUrl'] ?? 'https://via.placeholder.com/150', // 默认头像
      memberLevel: json['memberLevel'] ?? '普通会员',
      points: json['points'] ?? 0,
      healthRecord: json['healthRecord'],
    );
  }
}