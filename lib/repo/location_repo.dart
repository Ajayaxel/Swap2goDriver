import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap2godriver/config/api_config.dart';

class LocationRepository {
  Future<bool> updateLocation(double latitude, double longitude) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse(ApiConfig.updateLocation),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update location: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }
}
