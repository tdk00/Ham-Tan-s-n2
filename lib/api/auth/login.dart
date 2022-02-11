import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login {

  static Future<String> sendOtp ( String otp ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString('phone') ?? '';
    final uri =
    Uri.parse('http://178.62.249.150/api/account/login/');
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
    "username": phone,
    "password": otp
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    return await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ).then(onValue)
        .catchError(onError);

  }

  static Future<String> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);
    if( response.statusCode == 200 )
    {
      if( responseData['token'] != null )
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", responseData['token']);
        result = "success";
      }
    }
    else
    {
      result = 'error';
    }
    return result;
  }

  static onError(error){

    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }

}