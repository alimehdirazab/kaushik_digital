import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/Models/show_detail_model.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/httpErrorHandle.dart';
import '../utils/constants/snackbar.dart';

class HomeService {
  
//Get Shows API

  Future<Map<String, dynamic>> getShows({
    required BuildContext context,
  }) async {
    Map<String, dynamic> showsData = {};
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/shows'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      // print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            var responseData = jsonDecode(res.body);
            showsData = responseData;
            // print(responseData);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Something Went Wrong", context);
    }
    // print(homeMoviesData);
    return showsData;
  }

  //Get Popular Shows
  Future<Map<String, dynamic>> getPopularShows({
    required BuildContext context,
  }) async {
    Map<String, dynamic> showsData = {};
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/shows'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      // print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            var responseData = jsonDecode(res.body);
            showsData = responseData;
            // print(responseData);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Something Went Wrong", context);
    }
    // print(homeMoviesData);
    return showsData;
  }

  // Get Show Detail API

  Future<Show> fetchShowDetails({
    required int showId,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/show_details'),
        body: jsonEncode({
          "data": {"show_id": showId}
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        // print(res.body);
        final jsonResponse = jsonDecode(res.body);

        // Store the parsed response in a variable
        final showData = Show.fromJson(jsonResponse['VIDEO_STREAMING_APP']);
        print(showData);

        // Return the parsed Show object
        return showData;
      } else {
        snackbar("Something went wrong!Failed to load show details", context);

        throw Exception(
            "Failed to load show details. Status Code: ${res.statusCode}");
      }
    } catch (e) {
      // Handle errors like network issues or parsing errors
      print("Error fetching show details: $e");
      throw Exception("Error fetching show details: $e");
    }
  }










// Future<Map<String, dynamic>> getMovies({
  //   required BuildContext context,
  // }) async {
  //   Map<String, dynamic> homeMoviesData = {};
  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/home'),
  //       // body: jsonEncode({}),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     // print(res.body);
  //     httpErrorHandle(
  //         response: res,
  //         context: context,
  //         onSucess: () {
  //           var responseData = jsonDecode(res.body);
  //           homeMoviesData = responseData;
  //           // print(responseData);
  //         });
  //   } catch (e) {
  //     print(e.toString());
  //     snackbar("Something Went Wrong", context);
  //   }
  //   // print(homeMoviesData);
  //   return homeMoviesData;
  // }




// Update Profile
  // void UpdateProfile(
  //     {required String name,
  //     required String email,
  //     required String password,
  //     required String phone,
  //     required String address,
  //     required String userId,
  //     required BuildContext context}) async {
  //   try {
  //     // User user = User();

  //     UpdateProfileModel updateProfile = UpdateProfileModel(
  //         name: name,
  //         email: email,
  //         phone: phone,
  //         password: password,
  //         userAddress: address,
  //         userId: userId);
  //     print(updateProfile.toJson());
  //     // print(user.toJson());
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/profile_update'),
  //       body: jsonEncode({"data": updateProfile.toJson()}),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     print(jsonDecode(res.body));

  //     httpErrorHandle(
  //         response: res,
  //         context: context,
  //         onSucess: () {
  //           AuthService authService = AuthService();
  //           final profileProvider =
  //               Provider.of<ProfileDetailProvider>(context, listen: false);

  //           authService.getUserProfile(
  //             id: int.parse(userId),
  //             profileProvider: profileProvider,
  //           );
  //           var responseBody = jsonDecode(res.body);
  //           print(res.body);
  //           snackbar(responseBody["VIDEO_STREAMING_APP"][0]['msg'], context);

  //           //  Timer Navigator.pop(context);
  //           Timer(const Duration(seconds: 1), () {
  //             Navigator.pop(context);
  //           });
  //         });
  //   } catch (e) {
  //     print(e.toString());
  //     snackbar("Something Went Wrong", context);
  //   }
  // }

//Get Show details
  // Future<Show> getShowDetails({
  //   required int showId,
  //   required BuildContext context,
  // }) async {
  //   Map<String, dynamic>  showDetails ;
  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/show_details'),
  //       body: jsonEncode({
  //         "data": {"show_id": showId}
  //       }),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     // print(res.body);

  //     if (res.statusCode == 200) {
  //       final jsonResponse = jsonDecode(res.body);
  //       return Show.fromJson(jsonResponse['VIDEO_STREAMING_APP']);
  //     } else if (res.statusCode == 500){
  //       snackbar("Something went wrong! Try again later", context);

  //       throw Exception("Failed to load show details");
  //     }

  //     // httpErrorHandle(
  //     //     response: res,
  //     //     context: context,
  //     //     onSucess: () {
  //     //       var responseData = jsonDecode(res.body);

  //     //       // showDetails = responseData;
  //     //       // print(responseData);
  //     //     });
  //   } catch (e) {
  //     print(e.toString());
  //     snackbar("Something Went Wrong", context);
  //   }
  //  return Show.fromJson(jsonResponse['VIDEO_STREAMING_APP']);

  // }

//get languages
  // Future<List<dynamic>> fetchLanguages({required BuildContext context}) async {
  //   List<dynamic> languages = [];
  //   try {
  //     // Simulate an API call using your JSON response
  //     final response = await http.post(
  //       Uri.parse("$uri/languages"),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     httpErrorHandle(
  //         response: response,
  //         context: context,
  //         onSucess: () {
  //           final data = json.decode(response.body);

  //           languages = data["VIDEO_STREAMING_APP"];
  //         });
  //   } catch (error) {
  //     snackbar("Error Fetching data", context);
  //   }
  //   return languages;
  // }

  //get shows by languages

  // Future<Map<String, dynamic>> getShowsByLanguages({
  //   required int langId,
  //   required String filter,
  //   required BuildContext context,
  // }) async {
  //   Map<String, dynamic> showsByLanguages = {};
  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/shows_by_language'),
  //       body: jsonEncode({
  //         "data": {"lang_id": langId, "filter": filter}
  //       }),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     // print(res.body);
  //     httpErrorHandle(
  //         response: res,
  //         context: context,
  //         onSucess: () {
  //           var responseData = jsonDecode(res.body);
  //           showsByLanguages = responseData;
  //           // print(responseData);
  //         });
  //   } catch (e) {
  //     print(e.toString());
  //     snackbar("Something Went Wrong", context);
  //   }
  //   print(showsByLanguages);
  //   return showsByLanguages;
  // }
}
