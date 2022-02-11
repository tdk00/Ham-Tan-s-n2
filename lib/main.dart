import 'package:everyone_know_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app2.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token') ?? '';

  runApp(
    token.length > 1 ? MyApp2() : MyApp(),
  );
}
