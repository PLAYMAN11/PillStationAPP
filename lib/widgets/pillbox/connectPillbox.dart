import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillstationmovil/config/Bluetooth.dart';
import 'package:pillstationmovil/config/pill.dart';

class Connectpillbox extends StatefulWidget {
  const Connectpillbox({super.key});

  @override
  State<Connectpillbox> createState() => _ConnectpillboxState();
}

class _ConnectpillboxState extends State<Connectpillbox> {
  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    List<int> hours=[];
    List<int> minutes=[];
    int mayor = 0;
    for(Pill r in pillList){
      print("${8/r.hour}");
      mayor = (mayor > 8/r.hour ? mayor : 8/r.hour).toInt();
      for(int i=1; i<=mayor; i++) {
        hours.add((date.hour) + r.hour * i);
      }
    }
    for(int i=0; i<mayor; i++){
      minutes.add(date.minute);
    }
    hours = hours.toSet().toList();
    hours.sort();
    
    print("${mayor}");
    String datos = "{hours:${hours.toString()}, minutes:${minutes.toString()}}";
    print("${datos}");
    bluetooth.sendData(datos);
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400)),
              
            ])),
          ),
        ]),
      ),
    );
  }
}
