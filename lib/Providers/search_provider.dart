import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/constants/snackbar.dart';
import 'package:kaushik_digital/utils/httpErrorHandle.dart';

class SearchProvider extends ChangeNotifier {
  //Get all Languages API
  List<dynamic> languages = [];

  Future<void> fetchLanguages({required BuildContext context}) async {
    try {
      // Simulate an API call using your JSON response
      final response = await http.post(
        Uri.parse("$uri/languages"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSucess: () {
            final data = json.decode(response.body);

            languages = data["VIDEO_STREAMING_APP"];
            notifyListeners();
          });
    } catch (error) {
      snackbar("Error Fetching data", context);
    }
  }

  bool isLoading = false;
//Get all Show by language API
  Map<String, dynamic> showsByLanguages = {};
  Future<void> getShowsByLanguages({
    required int langId,
    required String filter,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      http.Response res = await http.post(
        Uri.parse('$uri/shows_by_language'),
        body: jsonEncode({
          "data": {"lang_id": langId, "filter": filter}
        }),
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
            showsByLanguages = responseData;
            isLoading = false;
            notifyListeners();
            // print(responseData);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Something Went Wrong", context);
    }
    print(showsByLanguages);
  }

  //
  //Get all Genres API
  List<dynamic> genres = [];

  Future<void> fetchGenre({required BuildContext context}) async {
    try {
      // Simulate an API call using your JSON response
      final response = await http.post(
        Uri.parse("$uri/genres"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSucess: () {
            final data = json.decode(response.body);

            genres = data["VIDEO_STREAMING_APP"];
            notifyListeners();
            print(genres);
          });
    } catch (error) {
      snackbar("Error Fetching data", context);
    }
  }

//Get all Show by Genres API
  // Map<String, dynamic> showsByGenres = {};
  Future<void> getShowsByGenres({
    required int langId,
    required String filter,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      http.Response res = await http.post(
        Uri.parse('$uri/shows_by_genre'),
        body: jsonEncode({
          "data": {"lang_id": langId, "filter": filter}
        }),
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
            showsByLanguages = responseData;
            isLoading = false;
            notifyListeners();
            // print(showsByGenres);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Something Went Wrong", context);
    }
    print(showsByLanguages);
  }
}
