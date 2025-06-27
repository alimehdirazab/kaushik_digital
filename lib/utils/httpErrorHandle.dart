// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/utils/constants/snackbar.dart';

void httpErrorHandle(
    {required http.Response response,
    required BuildContext context,
    required VoidCallback onSucess}) {
  switch (response.statusCode) {
    case 200:
      onSucess();
      break;
    case 400:
      print("Please Enter a valid email or password");
      snackbar("Please Enter a valid email or password.", context);
      break;
    case 500:
      print("SOmething went wrong! Try again later");
      snackbar("Unexpected error occur! Try again later", context);
      break;
    default:
      snackbar("Something went wrong! Try again later", context);
  }
}









// void httpErrorHandle({
//   required http.Response response,
//   required BuildContext context,
//   required VoidCallback onSucess,
// }) {
//   try {
//     final responseBody = jsonDecode(response.body);
//     final errorMessage = responseBody["VIDEO_STREAMING_APP"]?[0]["msg"] ??
//         "Something went wrong! Try again later";

//     switch (response.statusCode) {
//       case 200:
//         onSucess();
//         break;
//       case 400:
//         print("Error 400: ${response.body}");
//         snackbar(errorMessage, context);
//         break;
//       case 500:
//         print("Error 500: ${response.body}");
//         snackbar(errorMessage, context);
//         break;
//       default:
//         print("Unexpected Error (${response.statusCode}): ${response.body}");
//         snackbar("Unexpected error occurred. Please try again.", context);
//     }
//   } catch (e) {
//     print("Error decoding response: $e");
//     snackbar(
//         "Failed to process the response. Please try again later.", context);
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:kaushik_digital/utils/constants/snackbar.dart';

