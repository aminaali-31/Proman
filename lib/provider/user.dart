import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isLoggedIn = false;

  User? user; // ✅ Use model instead of Map

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    isLoading = false;

    if (result['message'] == "Login successful") {
      // ✅ Convert JSON to User model
      user = User.fromJson(result['user']);

      isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', result['token']); // JWT from server
      await prefs.setString('userEmail', result['user']['email']); // optional
      await prefs.setString('userName', result['user']['name']); // optional
      await prefs.setString('id', result['user']['id'].toString());
      await prefs.setString('role', result['user']['role']);
      notifyListeners();
      return true;
    }
    print(result['message']);
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    isLoading = true;
    notifyListeners();

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );

    isLoading = false;

    notifyListeners();

    return result['status'] == 'success';
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    user = null;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (loggedIn) {
      final email = prefs.getString('userEmail');
      final name = prefs.getString('userName');
      final id = prefs.getString('id');
      final role = prefs.getString('role');

      // Restore user model
      user = User(
        email: email ?? '',
        name: name ?? '',
        id: id ?? "",
        role: role ?? '',
      );
      isLoggedIn = true;

      notifyListeners();
    }
  }
}
