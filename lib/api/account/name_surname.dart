import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NameSurname {

  static Future<String> save ( String name, String surname, int business ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    final uri =
    Uri.parse('http://178.62.249.150/api/account/user/update/' + userId + '/');
    final headers = {'Content-Type': 'application/json', 'Authorization' : "Token " + token.toString()};

    Map<String, dynamic> body = {
      "business": business,
      "name": name,
      "surname": surname,

    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');


    return await put(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ).then(onValue)
        .catchError(onError);
  }

  static Future<String> getProfilePic () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    final uri =
    Uri.parse('http://178.62.249.150/api/account/user/'+ userId +'/');
    final headers = {'Content-Type': 'application/json', 'Authorization' : "Token " + token.toString()};

    Response response = await get(
        uri,
        headers: headers
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if(statusCode == 200 && jsonDecode(responseBody)['image'] != null )
      {
          return jsonDecode(responseBody)['image'];
      }

    return "error";
  }

  static Future<String> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);
    if( response.statusCode == 200 )
    {
      if( responseData['message'] != null )
      {
        result = 'sent';
      }
      else
      {
        result  = 'error';
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