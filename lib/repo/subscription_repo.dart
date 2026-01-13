import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap2godriver/config/api_config.dart';
import 'package:swap2godriver/models/subscription_model.dart';

class SubscriptionRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<SubscriptionResponse> getPlans() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.subscriptionPlans),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return SubscriptionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<PlanDetailsResponse> getPlanDetails(int id) async {
    try {
      final token = await _getToken();
      print('Fetching plan details for ID: $id');
      final response = await http.get(
        Uri.parse(ApiConfig.subscriptionPlanDetails(id)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Plan details response status: ${response.statusCode}');
      print('Plan details response body: ${response.body}');

      if (response.statusCode == 200) {
        return PlanDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load plan details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plan details: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<MySubscriptionResponse> getMySubscription() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.mySubscription),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return MySubscriptionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load subscription status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<PaymentInitializationResponse> initializePayment(int planId) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(ApiConfig.initializePayment),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'plan_id': planId}),
      );

      if (response.statusCode == 200) {
        return PaymentInitializationResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception('Failed to initialize payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
