import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:everyone_know_app/widget/story/story_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statuses {
  static Future<List<UserInfo>> getAll(locationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    var userId = prefs.getString('user_id') ?? '';
    final uri = Uri.parse('https://hamitanisin.digital/api/account/users/' + locationId.toString() + "/");
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Response response = await get(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    List<UserInfo> users = [];

    for (var u in jsonDecode(responseBody)) {
      UserInfo user = UserInfo(
        u['id'].toString(),
        u['name'].toString(),
        u['surname'].toString(),
        u['region'].toString(),
        u['business'].toString(),
        u['marriage'].toString(),
        u['image'].toString(),
        u['imagex'].toString(),
        u['number_hide'].toString(),
        u['about'].toString(),
      );

      users.add(user);
    }

    return users;
  }

  static Future<List<StoryItem>> getUserStatuses(userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    final uri = Uri.parse('https://hamitanisin.digital/api/status/list/' + userId.toString() + "/");
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Response response = await get(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;

    log('UserStatuses $responseBody');

    List<StoryItem> statuses = [];

    for (final u in jsonDecode(responseBody)) {
      final image = u['imagex'];
      final id = u['id'];
      final text = u['text'];

      log('STATUS ID $id');

      if (imageValid(image) && textValid(text)) {
        statuses.add(
          StoryItem.inlineImage(
            key: ValueKey(id),
            url: image,
            controller: StoryController(),
            imageFit: BoxFit.contain,
            caption: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 8.0,
                    color: Color.fromARGB(124, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
          //   StoryItem.inlineProviderImage(
          //     NetworkImage(image),
          //     key: ValueKey(id),
          //     caption: Text(
          //       text,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(
          //         color: Colors.black,
          //         fontSize: 18.0,
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //   ),
        );
      } else if (imageValid(image)) {
        statuses.add(
          StoryItem.inlineImage(
            key: ValueKey(id),
            url: image,
            controller: StoryController(),
            imageFit: BoxFit.contain,
          ),
        );
      } else if (textValid(text) && !imageValid(image)) {
        statuses.add(
          StoryItem.text(
            key: ValueKey(id),
            title: text,
            backgroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
            ),
          ),
        );
      }
    }

    return statuses.reversed.toList();
  }

  static Future<bool> deleteStatus(statusId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    final uri = Uri.parse('https://hamitanisin.digital/api/status/' + statusId.toString() + "/");
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Response response = await delete(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;

    log('DeleteStatus $responseBody');

    if (statusCode == 204) {
      print("removed");
      return true;
    } else {
      print("not removed");
      return false;
    }
  }
}

bool imageValid(String? image) {
  return image != null && image != '' || image != null;
}

bool textValid(String? text) {
  return text != null && text != '';
}

class UserInfo {
  final String id, name, surname, region, business, marriage, image, imageX, number_hide, about;
  UserInfo(this.id, this.name, this.surname, this.region, this.business, this.marriage, this.image, this.imageX, this.number_hide, this.about);
}

class StatusInfo {
  final String id, image, text, user;
  StatusInfo(this.id, this.image, this.text, this.user);
}
