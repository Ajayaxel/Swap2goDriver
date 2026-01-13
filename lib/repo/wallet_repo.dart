import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap2godriver/config/api_config.dart';
import 'package:swap2godriver/models/wallet_model.dart';

class WalletRepository {
  Future<WalletResponse> getWalletBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(ApiConfig.walletBalance),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return WalletResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          return WalletResponse(
            success: false,
            message: errorBody['message'] ?? 'Failed to fetch wallet balance',
          );
        } catch (_) {
          throw Exception(
            'Failed to fetch wallet balance: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<WalletDepositResponse> depositWallet(double amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse(ApiConfig.walletDeposit),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return WalletDepositResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          return WalletDepositResponse(
            success: false,
            message: errorBody['message'] ?? 'Failed to deposit to wallet',
          );
        } catch (_) {
          throw Exception(
            'Failed to deposit to wallet: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
