import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Otp {
  static Future<String> register(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String phone2 = phone.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '');
    phone2 = "994" + phone2;

    var regionId = prefs.getString('region_id') ?? '0';

    final uri = Uri.parse('http://178.62.249.150/api/account/register/');
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {"username": phone2, "region": regionId};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    log('$body');

    prefs.setString("phone", phone2);

    // final result = await http.post(uri, body: body);

    // log(result.body);

    return await http
        .post(
          uri,
          //   headers: headers,
          body: body,
          //   encoding: encoding,
        )
        .then(onValue)
        .catchError(onError);
  }

  static Future<String> onValue(http.Response response) async {
    String result;

    log(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseData['id'] != null && responseData['id'] > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", responseData['id'].toString());
        result = 'sent';
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", "0");
        result = 'error';
      }
    } else {
      result = 'error';
    }
    return result;
  }

  static onError(error) {
    debugPrint('the error is ${error.details}');

    return {
      'status': false,
      'message': 'Unsuccessful Request',
      'data': error,
    };
  }
}
