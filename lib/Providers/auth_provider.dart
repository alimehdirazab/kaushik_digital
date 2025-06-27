// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/Models/user_model.dart';
import 'package:kaushik_digital/Providers/user_provider.dart';
import 'package:kaushik_digital/Screens/Navbar/navbar.dart';
import 'package:kaushik_digital/Screens/otp%20Screen/otp_screen.dart';
import 'package:kaushik_digital/Services/auth_service.dart';
import 'package:kaushik_digital/utils/httpErrorHandle.dart';
import 'package:provider/provider.dart';

import '../Screens/Login/login_screen.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/snackbar.dart';
import 'home_data_provider.dart';
import 'profile_detail_provider.dart';
import 'search_provider.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  AuthService authService = AuthService();

//Login User With Email or Phone
  void loginUser(
      {required username,
      required password,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      http.Response res = await http.post(
        Uri.parse('$uri/login'),
        body: jsonEncode({
          "data": {
            "username": username,
            "password": password,
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        log(res.body);
        String responseBody = res.body;
        final jsonStartIndex = responseBody.indexOf('{');
        if (jsonStartIndex != -1) {
          responseBody = responseBody.substring(jsonStartIndex);
        }
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        // Check if login is successful
        if (responseData["VIDEO_STREAMING_APP"]?[0]["success"] == "1") {
          // Update the provider with login data
          Provider.of<UserProvider>(context, listen: false)
              .updateLoginData(responseData);
          final profileProvider =
              Provider.of<ProfileDetailProvider>(context, listen: false);
          bool profile = await authService.getUserProfile(
            id: responseData["VIDEO_STREAMING_APP"][0]["user_id"],
            profileProvider: profileProvider,
          );
          // Persist profile data
          await profileProvider.saveToPrefs();
          // authService.getUserDetails(
          //     id: responseData["VIDEO_STREAMING_APP"][0]["user_id"],
          //     context: context);
          if (!profile) {
            snackbar("Error getting profile details", context);
          }
          snackbar(responseData["VIDEO_STREAMING_APP"]?[0]["msg"], context);
          isLoading = false;
          notifyListeners();
          // Navigate to home or dashboard
          Provider.of<HomeDataProvider>(context, listen: false)
              .fetchVideoStreamingData(context: context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyNavBar()));

          Provider.of<SearchProvider>(context, listen: false)
              .fetchLanguages(context: context);
          Provider.of<SearchProvider>(context, listen: false)
              .fetchGenre(context: context);
        } else {
          // Handle unsuccessful login (show message and stop loading)
          snackbar(
              responseData["VIDEO_STREAMING_APP"]?[0]["msg"] ?? "Login failed",
              context);
          isLoading = false;
          notifyListeners();
        }
      } else if (res.statusCode == 400) {
        snackbar("Enter valid Email and Password", context);
        isLoading = false;
        notifyListeners();
      } else if (res.statusCode == 500) {
        snackbar("Something went wrong! Try again later", context);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        throw Exception("Failed to login. Status Code: ${res.statusCode}");
      }
    } catch (e) {
      print(e.toString());
      snackbar("Login Failed ", context);
      isLoading = false;
      notifyListeners();
    }
  }

//SignUp User
  void signUpUser(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required String otp,
      required String dob,
      String? refrence_id,
      required BuildContext context}) async {
    try {
      // User user = User();
      isLoading = true;
      notifyListeners();
      User user = User(
          name: name,
          email: email,
          phone: phone,
          password: password,
          otp: otp,
          dob: dob,
          referenceId: refrence_id);
      print(user.toJson());
      // print(user.toJson());
      http.Response res = await http.post(
        Uri.parse('$uri/signup'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print(jsonDecode(res.body));

      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            // var responseBody = jsonDecode(res.body);
            String responseBody = res.body;
            // Extract JSON part
            final jsonStartIndex = responseBody.indexOf('{');
            if (jsonStartIndex != -1) {
              responseBody = responseBody.substring(jsonStartIndex);
            }
//Decoding json response
            final Map<String, dynamic> responseData = jsonDecode(responseBody);
            if (responseData["VIDEO_STREAMING_APP"]?[0]["success"] == "1") {
              snackbar(responseData["VIDEO_STREAMING_APP"]?[0]["msg"], context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          });
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      snackbar("Something Went Wrong", context);
      isLoading = false;
      notifyListeners();
    }
  }

//Request OTP for Signup
  void requestOTP(
      {required String mobile, required BuildContext context}) async {
    try {
      print(mobile);
      isLoading = true;
      notifyListeners();
      http.Response res = await http.post(
        Uri.parse('$uri/request-otp'),
        body: jsonEncode({"mobile": mobile}),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            var responseBody = jsonDecode(res.body);
            snackbar(responseBody["message"], context, Colors.green);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const SignupScreen()));
          });
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      snackbar("Something Went Wrong", context);
      isLoading = false;
      notifyListeners();
    }
  }

//Request OTP for Login
  void requestLoginOTP(
      {required String mobile, required BuildContext context}) async {
    try {
      print(mobile);
      isLoading = true;
      notifyListeners();
      http.Response res = await http.post(
        Uri.parse('$uri/request-otp'),
        body: jsonEncode({"mobile": mobile}),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            var responseBody = jsonDecode(res.body);
            snackbar(responseBody["message"], context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(
                          phNo: mobile,
                        )));
          });
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());

      snackbar("Something Went Wrong", context);
      isLoading = false;
      notifyListeners();
    }
  }

//Verify OTP And Login

  void loginWithOTP(
      {required mobile, required otp, required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      http.Response res = await http.post(
        Uri.parse('$uri/loginwithotp'),
        body: jsonEncode({
          "data": {
            "mobile": mobile,
            "otp": otp,
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print(res.body);

      if (res.statusCode == 200) {
        String responseBody = res.body;
        // Extract JSON part
        final jsonStartIndex = responseBody.indexOf('{');
        if (jsonStartIndex != -1) {
          responseBody = responseBody.substring(jsonStartIndex);
        }
//Decoding json response
        final Map<String, dynamic> responseData = jsonDecode(responseBody);

        // Check if login is successful
        if (responseData["VIDEO_STREAMING_APP"]?[0]["success"] == "1") {
          // Update the provider with login data
          Provider.of<UserProvider>(context, listen: false)
              .updateLoginData(responseData);
          final profileProvider =
              Provider.of<ProfileDetailProvider>(context, listen: false);
          //Get User Profile
          bool profile = await authService.getUserProfile(
            id: responseData["VIDEO_STREAMING_APP"][0]["user_id"],
            profileProvider: profileProvider,
          );
          // Persist profile data
          await profileProvider.saveToPrefs();
          //Get user Data from Dashboard
          // authService.getUserDetails(
          //     id: responseData["VIDEO_STREAMING_APP"][0]["user_id"],
          //     context: context);
          if (!profile) {
            snackbar("Error getting profile details", context);
          }
          snackbar(responseData["VIDEO_STREAMING_APP"]?[0]["msg"], context);
          isLoading = false;
          notifyListeners();
          // Navigate to home or dashboard
          Provider.of<HomeDataProvider>(context, listen: false)
              .fetchVideoStreamingData(context: context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyNavBar()));

          Provider.of<SearchProvider>(context, listen: false)
              .fetchLanguages(context: context);
          Provider.of<SearchProvider>(context, listen: false)
              .fetchGenre(context: context);
        }
      } else if (res.statusCode == 400) {
        // Client Error: Bad Request
        snackbar("Enter valid Email and Password", context);
      } else if (res.statusCode == 500) {
        // Server Error: Internal Server Error
        snackbar("Something went wrong! Try again later", context);
      } else {
        throw Exception("Failed to login. Status Code: ${res.statusCode}");
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      snackbar("Login Failed ", context);
      isLoading = false;
      notifyListeners();
    }
  }
}
