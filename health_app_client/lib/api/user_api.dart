// lib/api/user_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

const String baseUrl = 'http://8.153.201.207:8080';

Future<String> addUser(User user) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/user/add'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(user.toJson()),
  );
  return response.body;
}

Future<User> getUserById(String id) async {
  final response = await http.get(Uri.parse('$baseUrl/api/user/$id'));
  return User.fromJson(json.decode(response.body));
}

Future<String> updateUser(User user) async {
  final response = await http.put(
    Uri.parse('$baseUrl/api/user/${user.serverId}'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(user.toJson()),
  );
  return response.body;
}

Future<String> deleteUser(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/api/user/$id'));
  return response.body;
}