import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/Models/lates_movie_model.dart';
import 'package:kaushik_digital/Models/latest_shows_model.dart';
import 'package:kaushik_digital/Models/popular_show_model.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:kaushik_digital/utils/constants/snackbar.dart';
import 'package:kaushik_digital/utils/httpErrorHandle.dart';

import '../Models/popular_movie_model.dart';

class ShowsServices {
  //Get Popular Shows
  Future<PopularShowModel?> getPopularShows({
    required BuildContext context,
  }) async {
    http.Response response;
    PopularShowModel? popularShows;
    try {
      response = await http.post(
        Uri.parse('$uri/popular_shows'),
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
            print(responseData);
            popularShows = PopularShowModel.fromJson(responseData);
          });
    } catch (e) {
      print('Exception: $e');
      snackbar("Something Went Wrong", context);
    }
    if (popularShows == null) {
      snackbar("Something Went Wrong", context);
    }
    print(" ye popular Show  data h${popularShows!.shows}");
    return popularShows;
  }

  //Get Popular Movies
  Future<PopularMovieModel?> getPopularMovies({
    required BuildContext context,
  }) async {
    http.Response response;
    PopularMovieModel? popularMovies;
    try {
      response = await http.post(
        Uri.parse('$uri/popular_movies'),
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
            // print(responseData);
            popularMovies = PopularMovieModel.fromJson(responseData);
          });
    } catch (e) {
      print('Exception: $e');
      snackbar("Something Went Wrong", context);
    }
    if (popularMovies == null) {
      snackbar("Something Went Wrong", context);
    }
    print(" ye popular Show  data h${popularMovies!.popularMovieList}");
    return popularMovies;
  }

  //Get Latest Shows
  Future<LatestShowsModel?> getLatestShows({
    required BuildContext context,
  }) async {
    http.Response response;
    LatestShowsModel? latestShows;
    try {
      response = await http.post(
        Uri.parse('$uri/latest_shows'),
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
            // print(responseData);
            latestShows = LatestShowsModel.fromJson(responseData);
          });
    } catch (e) {
      print('Exception: $e');
      snackbar("Something Went Wrong", context);
    }
    if (latestShows == null) {
      snackbar("Something Went Wrong", context);
    }
    print(" ye popular Show  data h${latestShows!.latesShowsList}");
    return latestShows;
  }

  //Get Latest Movies
  Future<LatesMovieModel?> getLatestMovies({
    required BuildContext context,
  }) async {
    http.Response response;
    LatesMovieModel? latestMovies;
    try {
      response = await http.post(
        Uri.parse('$uri/latest_movies'),
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
            // print(responseData);
            latestMovies = LatesMovieModel.fromJson(responseData);
          });
    } catch (e) {
      print('Exception: $e');
      snackbar("Something Went Wrong", context);
    }
    if (latestMovies == null) {
      snackbar("Something Went Wrong", context);
    }
    print(" ye popular Show  data h${latestMovies!.videoStreamingApp}");
    return latestMovies;
  }
}
