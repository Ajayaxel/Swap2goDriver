import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap2godriver/config/api_config.dart';
import 'package:swap2godriver/models/profile_model.dart';

class ProfileRepository {
  Future<ProfileResponse> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(ApiConfig.profile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Profile API Data: ${response.body}');
        return ProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<ProfileResponse> updateProfile(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.put(
        Uri.parse(ApiConfig.profile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          return ProfileResponse(
            success: false,
            message: errorBody['message'] ?? 'Failed to update profile',
          );
        } catch (_) {
          throw Exception('Failed to update profile: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<ProfileResponse> updateAvailability(bool isOnline) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final body = {'availability_status': isOnline ? 'available' : 'offline'};

      print('Updating availability: $body');

      final response = await http.post(
        Uri.parse(ApiConfig.updateAvailability),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print(
        'Availability update response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          return ProfileResponse(
            success: false,
            message: errorBody['message'] ?? 'Failed to update availability',
          );
        } catch (_) {
          throw Exception(
            'Failed to update availability: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
