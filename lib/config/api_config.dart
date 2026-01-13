class ApiConfig {
  static const String baseUrl = 'https://swap2go.com/api/driver';

  // Auth
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';
  static const String updateAvailability = '$baseUrl/update-availability';
  static const String updateLocation = '$baseUrl/update-location';

  // Wallet
  static const String walletBalance = '$baseUrl/wallet/balance';
  static const String walletDeposit = '$baseUrl/wallet/deposit';

  // Subscription
  static const String subscriptionPlans = '$baseUrl/subscription/plans';
  static const String mySubscription = '$baseUrl/subscription/my-subscription';
  static const String initializePayment =
      '$baseUrl/subscription/initialize-payment';

  static String subscriptionPlanDetails(int id) =>
      '$baseUrl/subscription/plans/$id';
}
