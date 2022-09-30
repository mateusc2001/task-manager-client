import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/screen/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: TextTheme(
            headline1: TextStyle(color: Colors.white),
            headline2: TextStyle(color: Colors.red),
            bodyText2: TextStyle(color: Colors.purple),
            subtitle1: TextStyle(color: Colors.white),
          )),
      home: LoginScreen(),
    );
  }
}

final storage = FlutterSecureStorage();
