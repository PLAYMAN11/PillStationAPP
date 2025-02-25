import 'package:flutter/material.dart';

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
    title: "Memorama",
  //  theme: ThemeData(fontFamily: "outfit", primarySwatch:Colors.lightBlue),
    initialRoute: "home",
    routes: {"home":(BuildContext)=> const Home()},
   );
  }
}
