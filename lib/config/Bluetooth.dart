import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';

Bluetooth bluetooth = Bluetooth();
class Bluetooth {
  final _bluetoothConexion = BluetoothClassic();
  bool isScanning = false;
  bool isConnected = false;


  Future<bool> connect() async {
    await _bluetoothConexion.initPermissions();
    await _bluetoothConexion.startScan();
    await _bluetoothConexion.onDeviceDiscovered().forEach((element) async {
      if (element.name == "PillStation") {
        print("DEVICE NAME: ${element.name}");
        await _bluetoothConexion.connect(
            element.address, "00001101-0000-1000-8000-00805F9B34FB");
        _bluetoothConexion.write("{hour : [9], minutes: [17]}");
        isConnected = true;
        await _bluetoothConexion.stopScan();
      }
      print("DEVICE NAME: ${element.name}");
    });

    return isConnected;
  }
}