import 'package:everyone_know_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token') ?? '';

  final userLogged = token.length > 1;

  runApp(
    MyApp(userLogged),
  );
}
