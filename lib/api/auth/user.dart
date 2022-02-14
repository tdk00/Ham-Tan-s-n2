import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  static Future<String> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    var userId = prefs.getString('user_id') ?? '';
    final uri = Uri.parse('http://hamitanisin.digital/api/account/user/' + userId + "/");
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    return await get(
      uri,
      headers: headers,
    ).then(onValue).catchError(onError);
  }

  static Future<String> onValue(Response response) async {
    String result;

    print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (responseData['name'] != null && responseData['surname'] != null && responseData['business'] != null) {
        result = "completed";
      } else {
        result = "incomplete";
      }
    } else {
      result = 'incomplete';
    }
    return result;
  }

  static onError(error) {
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
