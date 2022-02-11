import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:everyone_know_app/api/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_viewer/models/story_item.dart';


class Statuses {

  static getAll ( locationId ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    var userId = prefs.getString('user_id') ?? '';
    final uri =
    Uri.parse('http://178.62.249.150/api/account/users/' + locationId.toString() + "/");
    final headers = {'Content-Type': 'application/json', 'Authorization' : "Token " + token.toString()};

    Response response = await get(
      uri,
      headers: headers
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    List<UserInfo> users = [];

    for (var u in jsonDecode(responseBody)) {

      print( u['name'] );
      UserInfo user =  UserInfo(
          u['id'].toString() ,
          u['name'].toString() ,
          u['surname'].toString()  ,
          u['region'].toString()  ,
          u['business'].toString() ,
          u['marriage'].toString() ,
          u['image'].toString(),
          u['number_hide'].toString(),
          u['about'].toString()
      );

      users.add(user);

    }

    print("aaaa");
    return users;

  }

  static getUserStatuses ( userId ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    final uri =
    Uri.parse('http://178.62.249.150/api/status/list/' + userId.toString() + "/");
    final headers = {'Content-Type': 'application/json', 'Authorization' : "Token " + token.toString()};

    Response response = await get(
        uri,
        headers: headers
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    List<StoryItemModel> statuses = [];

    for (var u in jsonDecode(responseBody)) {
        //
        // StatusInfo status = StatusInfo(
        //     u['id'].toString(),
        //     u['image'].toString(),
        //     u['text'].toString(),
        //     u['user'].toString()
        // );

        statuses.add(
             StoryItemModel(
              imageProvider: NetworkImage(
                u['image'].toString()
              ),
            )
        );
    }
    return statuses;
  }


}

class UserInfo {
  final String id, name, surname, region, business, marriage, image, number_hide, about;
  UserInfo(this.id, this.name, this.surname, this.region, this.business, this.marriage, this.image, this.number_hide, this.about);
}


class StatusInfo {
  final String id, image, text, user;
  StatusInfo(this.id, this.image, this.text, this.user);
}