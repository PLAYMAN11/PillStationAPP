import 'package:flutter/material.dart';
import 'package:pillstationmovil/config/Bluetooth.dart';

class Connectpillbox extends StatefulWidget {
  const Connectpillbox({super.key});

  @override
  State<Connectpillbox> createState() => _ConnectpillboxState();
}

class _ConnectpillboxState extends State<Connectpillbox> {
  @override
  void initState() {
    super.initState();
    bluetooth.TurnOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(children: [
          Flexible(
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: "Conectando al dispositivo.\n",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700)),
              TextSpan(
                  text:
                      "Asegurese de haber habilitado el dispositivo como se muestra en el video de abajo",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400))
            ])),
          ),
        ]),
      ),
    );
  }
}
