
class WalletResponse {
  final bool success;
  final WalletData? data;
  final String message;

  WalletResponse({required this.success, this.data, required this.message});

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? WalletData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

class WalletData {
  final int walletId;
  final String balance;
  final num availableBalance;
  final String reservedBalance;
  final String currency;
  final String status;
  final String? lastTransactionAt;

  WalletData({
    required this.walletId,
    required this.balance,
    required this.availableBalance,
    required this.reservedBalance,
    required this.currency,
    required this.status,
    this.lastTransactionAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      walletId: json['wallet_id'] ?? 0,
      balance: json['balance'] ?? '0.00',
      availableBalance: json['available_balance'] ?? 0,
      reservedBalance: json['reserved_balance'] ?? '0.00',
      currency: json['currency'] ?? 'AED',
      status: json['status'] ?? 'active',
      lastTransactionAt: json['last_transaction_at'],
    );
  }
}

class WalletDepositResponse {
  final bool success;
  final WalletDepositData? data;
  final String message;

  WalletDepositResponse({
    required this.success,
    this.data,
    required this.message,
  });

  factory WalletDepositResponse.fromJson(Map<String, dynamic> json) {
    return WalletDepositResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? WalletDepositData.fromJson(json['data'])
          : null,
      message: json['message'] ?? '',
    );
  }
}

class WalletDepositData {
  final String paymentId;
  final String intentionId;
  final String paymentUrl;
  final num amount;
  final String currency;
  final String status;

  WalletDepositData({
    required this.paymentId,
    required this.intentionId,
    required this.paymentUrl,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory WalletDepositData.fromJson(Map<String, dynamic> json) {
    return WalletDepositData(
      paymentId: json['payment_id'] ?? '',
      intentionId: json['intention_id'] ?? '',
      paymentUrl: json['payment_url'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'AED',
      status: json['status'] ?? 'pending',
    );
  }
}
