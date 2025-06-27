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
import '../Services/auth_service.dart';

class HomeDataProvider extends ChangeNotifier {
  bool isLoading = false;
  VideoStreamingApp? videoStreamingApp;

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
            var responseData = jsonDecode(response.body);
            videoStreamingApp =
                VideoStreamingApp.fromJson(responseData['VIDEO_STREAMING_APP']);
            isLoading = false;
            notifyListeners();
            // print(responseData);
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
}
