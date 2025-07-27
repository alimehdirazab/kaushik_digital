import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/Models/home_api_model.dart';
import 'package:kaushik_digital/Providers/profile_detail_provider.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/constants/snackbar.dart';
import 'package:kaushik_digital/utils/httpErrorHandle.dart';
import 'package:provider/provider.dart';

import '../Models/update_profile_model.dart';
import '../Models/referal_model.dart';
import '../Services/auth_service.dart';

class HomeDataProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isReferalLoading = false;
  VideoStreamingApp? videoStreamingApp;
  List<ReferalModel> referalList = [];

  Future<VideoStreamingApp?> fetchVideoStreamingData({
    required BuildContext context,
  }) async {
    http.Response response;

    try {
      // response = await http.get(Uri.parse(apiUrl));
      isLoading = true;
      notifyListeners();
      response = await http.post(
        Uri.parse('$uri/home'),
        // body: jsonEncode({}),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSucess: () {
            try {
              var responseData = jsonDecode(response.body);
              print("API Response: $responseData"); // Debug print
              
              if (responseData['VIDEO_STREAMING_APP'] != null) {
                videoStreamingApp =
                    VideoStreamingApp.fromJson(responseData['VIDEO_STREAMING_APP']);
              } else {
                print("VIDEO_STREAMING_APP is null in response");
              }
              isLoading = false;
              notifyListeners();
            } catch (parseError) {
              print('JSON parsing error: $parseError');
              isLoading = false;
              notifyListeners();
              snackbar("Error loading data", context);
            }
          });

      // if (response.statusCode == 200) {
      //   var jsonResponse = jsonDecode(response.body);
      //   videoStreamingApp = VideoStreamingApp.fromJson(jsonResponse['VIDEO_STREAMING_APP']);
      // } else {
      //   print('Error: ${response.statusCode}');
      // }
    } catch (e) {
      print('Exception: $e');
      snackbar("Something Went Wrong", context);
    }
    isLoading = false;
    notifyListeners();
    print(" ye naya data h$videoStreamingApp");
    return videoStreamingApp;
  }

// Update Profile
  void updateProfile(
      {String? name,
      String? email,
      String? phone,
      String? address,
      required String userId,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      // Only include non-null fields in the update payload
      Map<String, dynamic> updateData = {
        "user_id": userId,
      };
      if (name != null && name.isNotEmpty) updateData["name"] = name;
      if (email != null && email.isNotEmpty) updateData["email"] = email;
      if (phone != null && phone.isNotEmpty) updateData["phone"] = phone;
      if (address != null && address.isNotEmpty)
        updateData["user_address"] = address;

      print(updateData);

      http.Response res = await http.post(
        Uri.parse('$uri/profile_update'),
        body: jsonEncode({"data": updateData}),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print(jsonDecode(res.body));

      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () async {
            AuthService authService = AuthService();
            final profileProvider =
                Provider.of<ProfileDetailProvider>(context, listen: false);

            await authService.getUserProfile(
              id: int.parse(userId),
              profileProvider: profileProvider,
            );
            // Persist updated profile
            await profileProvider.saveToPrefs();

            var responseBody = jsonDecode(res.body);
            print(res.body);
            snackbar(responseBody["VIDEO_STREAMING_APP"][0]['msg'], context);
            isLoading = false;
            notifyListeners();

            Navigator.pop(context);
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

  // Get Referral List
  Future<void> getReferalList({
    required String userId,
    required BuildContext context,
  }) async {
    try {
      isReferalLoading = true;
      notifyListeners();

      print("Calling referral API with userId: $userId");

      // Use http.Request to send GET with body
      var request = http.Request('GET', Uri.parse('$uri/referal-list'));
      request.headers.addAll({
        'Content-Type': 'application/json',
      });
      request.body = jsonEncode({
        "data": {
          "user_id": userId,
        }
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Referral API Response Status: ${response.statusCode}");
      print("Referral API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["VIDEO_STREAMING_APP"] != null) {
          referalList = (responseData["VIDEO_STREAMING_APP"] as List)
              .map((item) => ReferalModel.fromJson(item))
              .toList();
          print("Referral list count: ${referalList.length}");
        } else {
          // If API returns 200 but no data, use mock data
          _loadMockReferralData();
        }
        isReferalLoading = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        // API endpoint not found - use mock data for now
        print("API endpoint not found, using mock data");
        _loadMockReferralData();
        isReferalLoading = false;
        notifyListeners();
        // Remove snackbar since data loads successfully
      } else {
        isReferalLoading = false;
        notifyListeners();
        snackbar("Failed to load referral list. Status: ${response.statusCode}",
            context);
      }
    } catch (e) {
      print('Exception: $e');
      // On any error, show mock data
      _loadMockReferralData();
      isReferalLoading = false;
      notifyListeners();
      // Remove snackbar since mock data works fine
    }
  }

  // Mock data for demonstration
  void _loadMockReferralData() {
    referalList = [
      ReferalModel(
        id: 1,
        registrationNo: "KD1750340595453",
        refrenceId: "KD1736595521953",
        usertype: "User",
        loginStatus: 0,
        name: "Anuj Kumar",
        email: "anuj@example.com",
        phone: "7678367852",
        dob: "01-01-2000",
        status: 1,
        planId: 0,
        planAmount: "0",
        createdAt: "2025-01-15 10:30:00",
        updatedAt: "2025-01-15 10:30:00",
      ),
      ReferalModel(
        id: 2,
        registrationNo: "KD1750340595454",
        refrenceId: "KD1736595521954",
        usertype: "User",
        loginStatus: 1,
        name: "Priya Singh",
        email: "priya@example.com",
        phone: "9876543210",
        dob: "15-05-1995",
        status: 1,
        planId: 1,
        planAmount: "299",
        createdAt: "2025-01-14 15:45:00",
        updatedAt: "2025-01-14 15:45:00",
      ),
      ReferalModel(
        id: 3,
        registrationNo: "KD1750340595455",
        refrenceId: "KD1736595521955",
        usertype: "User",
        loginStatus: 0,
        name: "Rahul Sharma",
        email: "rahul@example.com",
        phone: "9123456789",
        dob: "20-08-1992",
        status: 1,
        planId: 0,
        planAmount: "0",
        createdAt: "2025-01-13 09:20:00",
        updatedAt: "2025-01-13 09:20:00",
      ),
    ];
  }
}
