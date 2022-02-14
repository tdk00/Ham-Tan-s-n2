import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {

  static Future<List<ProfileInfo>> getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    final uri = Uri.parse('http://178.62.249.150/api/account/user/' + 32.toString() + '/');
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Response response = await get(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;

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
              res['number_hide'].toString(),
              res['about'].toString())
      );

    }

    return profileInfo;
  }

}

class ProfileInfo {
  final String id, name, surname, region, business, marriage, image, number_hide, about;
  ProfileInfo(this.id, this.name, this.surname, this.region, this.business, this.marriage, this.image, this.number_hide, this.about);
}
