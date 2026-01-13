import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap2godriver/config/api_config.dart';
import 'package:swap2godriver/models/auth_model.dart';

class AuthRepository {
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        // Handle non-200 responses that might still be valid JSON error messages
        try {
          final errorBody = jsonDecode(response.body);
          return LoginResponse(
            success: false,
            message: errorBody['message'] ?? 'Login failed',
          );
        } catch (_) {
          throw Exception('Failed to login: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          return LoginResponse(
            success: false,
            message: errorBody['message'] ?? 'Registration failed',
          );
        } catch (_) {
          throw Exception('Failed to register: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        await http.post(
          Uri.parse(ApiConfig.logout),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Log error but don't block local logout
      print('Logout API error: $e');
    }
  }
}
