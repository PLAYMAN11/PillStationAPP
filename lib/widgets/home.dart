import 'package:flutter/material.dart';
import 'package:pillstationmovil/widgets/connectPillbox.dart';

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
              style: TextStyle(
                  color: Colors.blueAccent,
                  
                  fontSize: 60,
                  fontFamily: 'League',
                  fontWeight: FontWeight.w900),
                  
            ),
            ElevatedButton(
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Connectpillbox()))
                }, child: Text("Conectar a un pastillero"))
          ],
        ),
      ),
    );
  }
}
