class SubscriptionPlan {
  final int id;
  final String name;
  final String? description;
  final String amount;
  final String currency;
  final String interval;
  final int intervalCount;
  final int trialPeriodDays;
  final int maxBatteries;
  final int? maxSwapsPerMonth;
  final bool priorityAccess;
  final bool freeDelivery;
  final String status;

  SubscriptionPlan({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    required this.currency,
    required this.interval,
    required this.intervalCount,
    required this.trialPeriodDays,
    required this.maxBatteries,
    this.maxSwapsPerMonth,
    required this.priorityAccess,
    required this.freeDelivery,
    required this.status,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
      currency: json['currency'],
      interval: json['interval'],
      intervalCount: json['interval_count'],
      trialPeriodDays: json['trial_period_days'],
      maxBatteries: json['max_batteries'],
      maxSwapsPerMonth: json['max_swaps_per_month'],
      priorityAccess:
          json['priority_access'] == 1 || json['priority_access'] == true,
      freeDelivery: json['free_delivery'] == 1 || json['free_delivery'] == true,
      status: json['status'],
    );
  }
}

class SubscriptionResponse {
  final bool success;
  final String message;
  final List<SubscriptionPlan> plans;

  SubscriptionResponse({
    required this.success,
    required this.message,
    required this.plans,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['plans'] as List;
    List<SubscriptionPlan> plansList = list
        .map((i) => SubscriptionPlan.fromJson(i))
        .toList();

    return SubscriptionResponse(
      success: json['success'],
      message: json['message'],
      plans: plansList,
    );
  }
}

class PlanDetailsResponse {
  final bool success;
  final String message;
  final SubscriptionPlan? plan;

  PlanDetailsResponse({
    required this.success,
    required this.message,
    this.plan,
  });

  factory PlanDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlanDetailsResponse(
      success: json['success'],
      message: json['message'],
      plan: json['data'] != null
          ? SubscriptionPlan.fromJson(json['data'])
          : null,
    );
  }
}

class MySubscriptionResponse {
  final bool success;
  final String message;
  final dynamic data; // Can be null or subscription details

  MySubscriptionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return MySubscriptionResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class PaymentInitializationResponse {
  final bool success;
  final String message;
  final PaymentData? data;

  PaymentInitializationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PaymentInitializationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitializationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }
}

class PaymentData {
  final int subscriptionId;
  final String intentionId;
  final String paymentUrl;
  final String clientSecret;
  final String publicKey;
  final String amount;
  final String currency;

  PaymentData({
    required this.subscriptionId,
    required this.intentionId,
    required this.paymentUrl,
    required this.clientSecret,
    required this.publicKey,
    required this.amount,
    required this.currency,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      subscriptionId: json['subscription_id'],
      intentionId: json['intention_id'],
      paymentUrl: json['payment_url'],
      clientSecret: json['client_secret'],
      publicKey: json['public_key'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }
}
