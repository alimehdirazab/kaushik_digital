import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? userId;
  String? name;
  String? email;
  String? userImage;
  String? message;
  bool isSuccess = false;

  // Update the provider data based on the response
  void updateLoginData(Map<String, dynamic> response) {
    print("start");
    final data = response["VIDEO_STREAMING_APP"][0];
    userId = data["user_id"];
    name = data["name"];
    email = data["email"];
    userImage = data["user_image"];
    message = data["msg"];
    isSuccess = data["success"] == "1";

    print(" userid $userId");
    print("name $name");
    print("email $email");
    print("image $userImage");
    print(" message $message");
    notifyListeners(); // Notify widgets to rebuild
  }

  // Clear user data (useful for logout)
  void clearData() {
    userId = null;
    name = null;
    email = null;
    userImage = null;
    message = null;
    isSuccess = false;

    notifyListeners();
  }
}
