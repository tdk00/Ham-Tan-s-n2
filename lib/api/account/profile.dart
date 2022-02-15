import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  static Future<List<ProfileInfo>> getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    final uri = Uri.parse('https://hamitanisin.digital/api/account/user/' + userId + '/');
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Response response = await get(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;

    log(responseBody);

    List<ProfileInfo> profileInfo = [];

    if (statusCode == 200) {
      var res = jsonDecode(responseBody);
      profileInfo.add(
        ProfileInfo(
          res['id'].toString(),
          res['name'].toString(),
          res['surname'].toString(),
          res['region'].toString(),
          res['business'].toString(),
          res['marriage'].toString(),
          res['image'].toString(),
          res['imagex'].toString(),
          res['number_hide'].toString(),
          res['about'].toString(),
        ),
      );
    }

    return profileInfo;
  }

  static saveProfileInfo(String name, String surname, String marriage, String business, String about) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    final uri = Uri.parse('https://hamitanisin.digital/api/account/user/update/' + userId + '/');
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    print(userId + "usssss");
    Map<String, dynamic> body = {"name": name, "surname": surname, "about": about, "marriage": marriage, "business": 1};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await patch(uri, headers: headers, body: jsonBody, encoding: encoding);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(responseBody);

    if (statusCode == 200) {
      return "ok";
    }

    return "error";
  }
}

class ProfileInfo {
  final String id, name, surname, region, business, marriage, image, imageX, number_hide, about;
  ProfileInfo(this.id, this.name, this.surname, this.region, this.business, this.marriage, this.image, this.imageX, this.number_hide, this.about);
}
