import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameSurname {
  static Future<String> save(String name, String surname, int business) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    business = business < 1 ? 1 : business;
    final uri = Uri.parse('https://hamitanisin.digital/api/account/user/update/' + userId + '/');
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Map<String, dynamic> body = {"business": business, "name": name, "surname": surname};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await put(uri, headers: headers, body: jsonBody, encoding: encoding);

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200 && jsonDecode(responseBody)['image'] != null) {
      return jsonDecode(responseBody)['image'];
    }

    return "error";

    return await put(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ).then(onValue).catchError(onError);
  }

  static Future<String> getProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var token = prefs.getString('token') ?? '';
    final uri = Uri.parse('https://hamitanisin.digital/api/account/user/' + userId + '/');
    final headers = {'Content-Type': 'application/json', 'Authorization': "Token " + token.toString()};

    Response response = await get(uri, headers: headers);

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200 && jsonDecode(responseBody)['image'] != null) {
      return jsonDecode(responseBody)['image'];
    }

    return "error";
  }

  static Future<String> onValue(Response response) async {
    String result;

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (responseData['message'] != null) {
        result = 'sent';
      } else {
        result = 'error';
      }
    } else {
      result = 'error';
    }
    return result;
  }

  static onError(error) {
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
