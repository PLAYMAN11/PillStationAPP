import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillstationmovil/widgets/login.dart';

import 'home.dart';

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: "outfit", primarySwatch:Colors.lightBlue),
      theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.blue,
            onPrimary: Colors.black,
            secondary: Colors.black,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.redAccent,
            surface: Colors.white,
            onSurface: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
      ),
      initialRoute: "login",
      routes: {"login": (BuildContext) => Login()},
    );
  }
}
