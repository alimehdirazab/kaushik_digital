import 'package:flutter/material.dart';
import 'package:kaushik_digital/utils/preferences/user_preferences.dart';

class ProfileDetailProvider with ChangeNotifier {
  int? userId;
  String? name;
  String? email;
  String? userImage;
  String? phone;
  String? userAddress;
  String? msg;
  String? success;

  // Update the provider data based on the response
  void updateProfileDetails(Map<String, dynamic> response) {
    print("start");
    final data = response["VIDEO_STREAMING_APP"][0];
    userId = data["user_id"];
    name = data["name"];
    email = data["email"];
    userImage = data["user_image"];
    phone = data["phone"];
    userAddress = data["user_address"];
    msg = data["msg"];
    success = data["success"];

    print("user details provider");
    print(" userid $userId");
    print("name $name");
    print("email $email");
    print("image $userImage");
    print(" message $msg");
    print(" phone $phone");
    print(" userAddress $userAddress");
    print(" success $success");
    notifyListeners(); // Notify widgets to rebuild
    saveToPrefs();
  }

  // Save user data to SharedPreferences
  Future<void> saveToPrefs() async {
    await UserPreferences.saveProfile(
      userId: userId,
      name: name,
      email: email,
      userImage: userImage,
      phone: phone,
      userAddress: userAddress,
      msg: msg,
      success: success,
    );
  }

  // Load user data from SharedPreferences
  Future<void> loadFromPrefs() async {
    final data = await UserPreferences.loadProfile();
    userId = data['userId'];
    name = data['name'];
    email = data['email'];
    userImage = data['userImage'];
    phone = data['phone'];
    userAddress = data['userAddress'];
    msg = data['msg'];
    success = data['success'];
    notifyListeners();
  }

  // Clear user data (useful for logout)
  void clearData() async {
    userId = null;
    name = null;
    email = null;
    userImage = null;
    userAddress = null;
    phone = null;
    msg = null;
    success = null;

    await UserPreferences.clearProfile();

    notifyListeners();
  }
}
