class UpdateProfileModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String userAddress;
  final String password;

  UpdateProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.userAddress,
    required this.password,
  });

  // Factory constructor to create an instance from JSON
  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userAddress: json['user_address'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'user_address': userAddress,
      'password': password,
    };
  }
}
