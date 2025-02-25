import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            Text(
              "PillStation",
              style: TextStyle(color: Colors.blueAccent, fontSize: 60),
            ),
            ElevatedButton(
                onPressed: () => {}, child: Text("Conectar a un pastillero"))
          ],
        ),
      ),
    );
  }
}
