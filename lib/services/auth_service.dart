import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseUrl =
      "https://proapp.ariesware.com";

  Future login(
      String email,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "phone":phone,
          "role":role
        },
      );
      return jsonDecode(response.body);

    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }
  Future<Map<String, dynamic>> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String company,
  }) async {
    try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$baseUrl/auth/addClient"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "company": company,
      }),
    );

      print(response.body);
      return jsonDecode(response.body);

    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }
}