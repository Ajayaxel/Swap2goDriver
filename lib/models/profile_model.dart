class ProfileResponse {
  final bool success;
  final String message;
  final DriverProfile? data;

  ProfileResponse({required this.success, required this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data']['driver'] != null
          ? DriverProfile.fromJson(json['data']['driver'])
          : null,
    );
  }
}

class DriverProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String driverLicenseNumber;
  final String vehicleNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String? profilePhoto;
  final String? licensePhoto;
  final String? vehiclePhoto;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String status;
  final String availabilityStatus;
  final bool isVerified;
  final bool isOnline;

  DriverProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.driverLicenseNumber,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    this.profilePhoto,
    this.licensePhoto,
    this.vehiclePhoto,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.status,
    required this.availabilityStatus,
    required this.isVerified,
    required this.isOnline,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      driverLicenseNumber: json['driver_license_number'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      vehicleColor: json['vehicle_color'] ?? '',
      profilePhoto: json['profile_photo'],
      licensePhoto: json['license_photo'],
      vehiclePhoto: json['vehicle_photo'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      country: json['country'] ?? '',
      status: json['status'] ?? '',
      availabilityStatus: json['availability_status'] ?? '',
      isVerified: json['is_verified'] ?? false,
      isOnline: json['is_online'] ?? false,
    );
  }
}
