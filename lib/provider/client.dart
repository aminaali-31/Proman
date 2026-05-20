
import 'package:flutter/material.dart';
import 'package:proapp/services/auth_service.dart';

class ClientProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> createClient({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService().registerClient(
        name: name,
        email: email,
        password: password,
        phone: phone,
        company: company
      );

      isLoading = false;
      notifyListeners();

      if (response['status'] == 'success') {
      return true; // Client created
    } else {
      return false; // Failed to create client
    }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}