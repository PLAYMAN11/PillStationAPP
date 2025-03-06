
import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Bluetooth bluetooth = Bluetooth();
class Bluetooth{
  late StreamSubscription <List<ScanResult>> subscription;
  
  void TurnOn(){
    FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult r in results){
        if (r.device.advName == "PillStation") {
          r.device.connect();
        }
      }
    },
      onError: (e) => print(e),
    );
  }
}

