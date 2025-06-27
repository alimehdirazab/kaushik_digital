import 'package:flutter/material.dart';

class UserDetailsProvider with ChangeNotifier {
  int? userId;
  String? name;
  String? email;
  String? userImage;
  String? currentPlan;
  String? expiresOn;
  String? lastInvoiceDate;
  String? lastInvoicePlan;
  String? lastInvoiceAmount;
  String? msg;
  String? success;

  // Update the provider data based on the response
  void updateUserDetails(Map<String, dynamic> response) {
    print("start");
    final data = response["VIDEO_STREAMING_APP"][0];
    userId = data["user_id"];
    name = data["name"];
    email = data["email"];
    userImage = data["user_image"];
    currentPlan = data["current_plan"];
    expiresOn = data["expires_on"];
    lastInvoiceDate = data["last_invoice_date"];
    lastInvoicePlan = data["last_invoice_plan"];
    lastInvoiceAmount = data["last_invoice_amount"];
    msg = data["msg"];
    success = data["success"];

    notifyListeners(); // Notify widgets to rebuild
    print("user details provider");
    print(" userid $userId");
    print("name $name");
    print("email $email");
    print("image $userImage");
    print(" message $msg");
    print(" currentPlan $currentPlan");
    print(" expiresOn $expiresOn");
    print(" lastInvoiceDate $lastInvoiceDate");
    print(" lastInvoicePlan $lastInvoicePlan");
    print(" lastInvoiceAmount $lastInvoiceAmount");
    print(" success $success");
  }

  // Clear user data (useful for logout)
  void clearData() {
    userId = null;
    name = null;
    email = null;
    userImage = null;
    currentPlan = null;
    expiresOn = null;
    lastInvoiceDate = null;
    lastInvoicePlan = null;
    lastInvoiceAmount = null;
    msg = null;
    success = null;

    notifyListeners();
  }
}
