class LoginResponse {
  final bool success;
  final String message;
  final Data? data;

  LoginResponse({required this.success, required this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final Driver driver;
  final String token;
  final String tokenType;

  Data({required this.driver, required this.token, required this.tokenType});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      driver: Driver.fromJson(json['driver']),
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? '',
    );
  }
}

class Driver {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String driverLicenseNumber;
  final String vehicleNumber;
  final String vehicleType;
  final String status;
  final String availabilityStatus;
  final bool isVerified;
  final bool isOnline;
  final String createdAt;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.driverLicenseNumber,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.status,
    required this.availabilityStatus,
    required this.isVerified,
    required this.isOnline,
    required this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      driverLicenseNumber: json['driver_license_number'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      status: json['status'] ?? '',
      availabilityStatus: json['availability_status'] ?? '',
      isVerified: json['is_verified'] ?? false,
      isOnline: json['is_online'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String driverLicenseNumber;
  final String vehicleNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final int companyId;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.driverLicenseNumber,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'driver_license_number': driverLicenseNumber,
      'vehicle_number': vehicleNumber,
      'vehicle_type': vehicleType,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'address': address,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'company_id': companyId,
    };
  }
}
