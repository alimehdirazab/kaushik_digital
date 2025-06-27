import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaushik_digital/utils/constants/snackbar.dart';

import '../utils/constants/constants.dart';
import '../utils/httpErrorHandle.dart';

class AccountService {
  //Terms and Services
  Future<Map<String, dynamic>> termAndServices(BuildContext context) async {
    Map<String, dynamic> dataMap = {};

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/terms_conditions'), headers: {
        'Content-Type': 'application/json',
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            dataMap = jsonDecode(res.body);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Error fetching data ", context);
    }
    print(dataMap);
    return dataMap;
  }


  //Privacy and Policy
  Future<Map<String, dynamic>> privacyAndPolicy(BuildContext context) async {
    Map<String, dynamic> dataMap = {};

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/privacy_policy'), headers: {
        'Content-Type': 'application/json',
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            dataMap = jsonDecode(res.body);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Error fetching data ", context);
    }
    print(dataMap);
    return dataMap;
  }


//FAQs
  Future<Map<String, dynamic>> getFAQs(BuildContext context) async {
    Map<String, dynamic> dataMap = {};

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/faq'), headers: {
        'Content-Type': 'application/json',
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            dataMap = jsonDecode(res.body);
          });
    } catch (e) {
      print(e.toString());
      snackbar("Error fetching data ", context);
    }
    print(dataMap);
    return dataMap;
  }

}
