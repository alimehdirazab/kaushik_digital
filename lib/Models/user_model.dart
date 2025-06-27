class User {
  final String name;
  final String email;
  final String phone;
  final String? referenceId; // Made nullable
  final String password;
  final String otp;
  final String dob;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.referenceId = '', // Nullable field
    required this.password,
    required this.otp,
    required this.dob,
  });

  // Factory method to create a User instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      referenceId: json['refrence_id'], // Nullable field
      password: json['password'],
      otp: json['otp'],
      dob: json['dob'],
    );
  }

  // Method to convert a User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'refrence_id': referenceId, // Nullable field
      'password': password,
      'otp': otp,
      'dob': dob,
    };
  }
}




// class User {
//   String name;
//   String email;
//   String password;

//   // Constructor
//   User({
//     required this.name,
//     required this.email,
//     required this.password,
//   });

//   // Factory method to create a User from JSON
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       name: json['name'],
//       email: json['email'],
//       password: json['password'],
//     );
//   }

//   // Method to convert User to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'email': email,
//       'password': password,
//     };
//   }
// }
