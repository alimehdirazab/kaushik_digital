// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/Models/user_model.dart';
import 'package:kaushik_digital/Providers/home_data_provider.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';
import 'package:kaushik_digital/Providers/search_provider.dart';
import 'package:kaushik_digital/Providers/user_details_provider.dart';
import 'package:kaushik_digital/Providers/user_provider.dart';
import 'package:kaushik_digital/Screens/Login/login_screen.dart';
import 'package:kaushik_digital/Screens/Navbar/navbar.dart';
import 'package:kaushik_digital/Screens/Signup/signup_screen.dart';
import 'package:kaushik_digital/Screens/otp%20Screen/otp_screen.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/constants/snackbar.dart';
import 'package:kaushik_digital/utils/httpErrorHandle.dart';
import 'package:provider/provider.dart';

class AuthService {
//getting user details from dashboard API
  void getUserDetails({required id, required BuildContext context}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/dashboard'),
        body: jsonEncode({
          "data": {
            "user_id": id,
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            String responseBody = res.body;
// Extract JSON part
            final jsonStartIndex = responseBody.indexOf('{');
            if (jsonStartIndex != -1) {
              responseBody = responseBody.substring(jsonStartIndex);
            }
//Decoding json response
            final Map<String, dynamic> responseData = jsonDecode(responseBody);
// Check if login is successful
            if (responseData["status_code"] == 200) {
              // Update the provider with login data
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .updateUserDetails(responseData);
            } else {
              // if any error
              print(responseData["VIDEO_STREAMING_APP"]?[0]["msg"]);
            }
          });
    } catch (e) {
      print(e.toString());
      snackbar("Login Failed ", context);
    }
  }

//get User Profile data

  Future<bool> getUserProfile({
    required id,
    required ProfileDetailProvider profileProvider,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/profile'),
        body: jsonEncode({
          "data": {
            "user_id": id,
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        String responseBody = res.body;
        final jsonStartIndex = responseBody.indexOf('{');
        if (jsonStartIndex != -1) {
          responseBody = responseBody.substring(jsonStartIndex);
        }
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        if (responseData["status_code"] == 200) {
          profileProvider.updateProfileDetails(responseData);
          // snackbar("Profile Data Updated",);
          return true;
        } else {
          print(responseData["VIDEO_STREAMING_APP"]?[0]["msg"]);
          return false;
        }
      } else {
        throw Exception(
            "Failed to fetch profile. Status Code: ${res.statusCode}");
      }
    } catch (e) {
      print("This is Error ${e.toString()}");
      return false;
    }
  }
}

// Signup Function API
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          }
        });
  } catch (e) {
    print(e.toString());
    snackbar("Something Went Wrong", context);
  }
}

//Login Function API
void loginUser(
    {required username,
    required password,
    required BuildContext context}) async {
  try {
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
      // print("responsedata");
      // print(responseData);

      // Check if login is successful
      if (responseData["VIDEO_STREAMING_APP"]?[0]["success"] == "1") {
        // Update the provider with login data
        Provider.of<UserProvider>(context, listen: false)
            .updateLoginData(responseData);

        getUserProfile(
            id: responseData["VIDEO_STREAMING_APP"][0]["user_id"],
            context: context);
        snackbar(responseData["VIDEO_STREAMING_APP"]?[0]["msg"], context);
        // Navigate to home or dashboard
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyNavBar()));
        Provider.of<HomeDataProvider>(context, listen: false)
            .fetchVideoStreamingData(context: context);
        Provider.of<SearchProvider>(context, listen: false)
            .fetchLanguages(context: context);
        Provider.of<SearchProvider>(context, listen: false)
            .fetchGenre(context: context);
      } else {
        // if any error
        snackbar(
            responseData["VIDEO_STREAMING_APP"]?[0]["msg"] ?? "Login failed",
            context);
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
  } catch (e) {
    print(e.toString());
    snackbar("Login Failed ", context);
  }
}

void getUserProfile({required id, required BuildContext context}) async {
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/profile'),
      body: jsonEncode({
        "data": {
          "user_id": id,
        }
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          String responseBody = res.body;
//         // Extract JSON part
          final jsonStartIndex = responseBody.indexOf('{');
          if (jsonStartIndex != -1) {
            responseBody = responseBody.substring(jsonStartIndex);
          }
//Decoding json response
          final Map<String, dynamic> responseData = jsonDecode(responseBody);
          // Check if login is successful
          if (responseData["status_code"] == 200) {
            // Update the provider with login data
            print(responseData);

            Provider.of<ProfileDetailProvider>(context, listen: false)
                .updateProfileDetails(responseData);
          } else {
            // if any error
            print(responseData["VIDEO_STREAMING_APP"]?[0]["msg"]);
            // snackbar(
            //     responseData["VIDEO_STREAMING_APP"]?[0]["msg"] ?? "Login failed",
            //     context);
          }
        });
    if (res.statusCode == 200) {
      String responseBody = res.body;
      // Extract JSON part
      final jsonStartIndex = responseBody.indexOf('{');
      if (jsonStartIndex != -1) {
        responseBody = responseBody.substring(jsonStartIndex);
      }
//Decoding json response
      final Map<String, dynamic> responseData = jsonDecode(responseBody);
      // print("responsedata");
      // print(responseData);

      // Check if login is successful
      if (responseData["status_code"] == 200) {
        // Update the provider with login data
        Provider.of<UserDetailsProvider>(context, listen: false)
            .updateUserDetails(responseData);
        // snackbar(responseData["VIDEO_STREAMING_APP"]?[0]["msg"], context);
        // Navigate to home or dashboard
      } else {
        // if any error
        print(responseData["VIDEO_STREAMING_APP"]?[0]["msg"]);
        // snackbar(
        //     responseData["VIDEO_STREAMING_APP"]?[0]["msg"] ?? "Login failed",
        //     context);
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
  } catch (e) {
    print("This is Error ${e.toString()}");
    // snackbar("Login Failed ", context);
  }
}

//Request OTP
void requestOTP({required String mobile, required BuildContext context}) async {
  try {
    print(mobile);
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignupScreen()));
        });
  } catch (e) {
    print(e.toString());

    snackbar("Something Went Wrong", context);
  }
}

//Request Login OTP
void requestLoginOTP(
    {required String mobile, required BuildContext context}) async {
  try {
    print(mobile);
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        phNo: mobile,
                      )));
        });
  } catch (e) {
    print(e.toString());

    snackbar("Something Went Wrong", context);
  }
}

// Login With OTP

//   void loginWithOTP(
//       {required mobile, required otp, required BuildContext context}) async {
//     try {
//       http.Response res = await http.post(
//         Uri.parse('$uri/loginwithotp'),
//         body: jsonEncode({
//           "data": {
//             "mobile": mobile,
//             "otp": otp,
//           }
//         }),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//       );
//       print(res.body);

//       if (res.statusCode == 200) {
//         String responseBody = res.body;
//         // Extract JSON part
//         final jsonStartIndex = responseBody.indexOf('{');
//         if (jsonStartIndex != -1) {
//           responseBody = responseBody.substring(jsonStartIndex);
//         }
// //Decoding json response
//         final Map<String, dynamic> responseData = jsonDecode(responseBody);
//         // print("responsedata");
//         // print(responseData);

//         // Check if login is successful
//         if (responseData["VIDEO_STREAMING_APP"]?[0]["success"] == "1") {
//           // Update the provider with login data
//           Provider.of<UserProvider>(context, listen: false)
//               .updateLoginData(responseData);

//           getUserProfile(
//               id: responseData["VIDEO_STREAMING_APP"][0]["user_id"],
//               context: context);
//           snackbar(responseData["VIDEO_STREAMING_APP"]?[0]["msg"], context);
//           // Navigate to home or dashboard
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const MyNavBar()));
//           Provider.of<HomeDataProvider>(context, listen: false)
//               .fetchVideoStreamingData(context: context);
//           Provider.of<SearchProvider>(context, listen: false)
//               .fetchLanguages(context: context);
//           Provider.of<SearchProvider>(context, listen: false)
//               .fetchGenre(context: context);
//         } else {
//           // if any error
//           snackbar(
//               responseData["VIDEO_STREAMING_APP"]?[0]["msg"] ?? "Login failed",
//               context);
//         }
//       } else if (res.statusCode == 400) {
//         // Client Error: Bad Request
//         snackbar("Enter valid Email and Password", context);
//       } else if (res.statusCode == 500) {
//         // Server Error: Internal Server Error
//         snackbar("Something went wrong! Try again later", context);
//       } else {
//         throw Exception("Failed to login. Status Code: ${res.statusCode}");
//       }
//     } catch (e) {
//       print(e.toString());
//       snackbar("Login Failed ", context);
//     }
//   }

//   // Future<void> getUser(BuildContext context) async {
//   //   try {
//   //     print("starting");
//   //     final SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? token = prefs.getString('x-auth-token');
//   //     print(token);
//   //     if (token == null) {
//   //       prefs.setString('x-auth-token', '');
//   //     }
//   //     if (token != null) {
//   //       var tokenRes = await http.post(Uri.parse("$uri/tokenValidity"),
//   //           headers: {
//   //             'Content-Type': 'application/json',
//   //             'x-auth-token': token
//   //           });
//   //       var response = jsonDecode(tokenRes.body);
//   //       if (response == true) {
//   //         http.Response userRes = await http.get(Uri.parse(uri), headers: {
//   //           'Content-Type': 'application/json',
//   //           'x-auth-token': token
//   //         });
//   //         print(userRes.body);
//   //         Provider.of<UserProvider>(context, listen: false)
//   //             .setUser(userRes.body);
//   //         print("done");
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print(e.toString());
//   //     // showToast(context: context, text: e.toString(), icon: Icons.delete);
//   //   }
//   // }
// }
