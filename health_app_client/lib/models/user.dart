// lib/models/user.dart
class User {
  final String id;
  final String username;
  final String password;
  final int? serverId;
  final String? name;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final String? constitutionType;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.username,
    required this.password,
    this.serverId,
    this.name,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.constitutionType,
    this.avatarUrl,
  });

  // ✅ 这就是你缺失的根源解决方法
  factory User.empty() => const User(
    id: '',
    username: '',
    password: '',
    serverId: null,
    name: null,
    gender: null,
    age: null,
    height: null,
    weight: null,
    allergies: [],
    chronicDiseases: [],
    constitutionType: null,
    avatarUrl: null,
  );

  User copyWith({
    String? id,
    String? username,
    String? password,
    int? serverId,
    String? name,
    String? gender,
    int? age,
    double? height,
    double? weight,
    List<String>? allergies,
    List<String>? chronicDiseases,
    String? constitutionType,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      constitutionType: constitutionType ?? this.constitutionType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'password': password,
    'serverId': serverId,
    'name': name,
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight,
    'allergies': allergies,
    'chronicDiseases': chronicDiseases,
    'constitutionType': constitutionType,
    'avatarUrl': avatarUrl,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id']?.toString() ?? '',
    username: json['username'] ?? '',
    password: json['password'] ?? '',
    serverId: json['serverId'] as int?,
    name: json['name'] as String?,
    gender: json['gender'] as String?,
    age: json['age'] as int?,
    height: json['height']?.toDouble(),
    weight: json['weight']?.toDouble(),
    allergies: (json['allergies'] as List<dynamic>?)?.cast<String>() ?? [],
    chronicDiseases:
    (json['chronicDiseases'] as List<dynamic>?)?.cast<String>() ?? [],
    constitutionType: json['constitutionType'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
  );
}