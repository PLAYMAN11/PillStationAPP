import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';


Bluetooth bluetooth = Bluetooth();
class Bluetooth {
  final _bluetoothConexion = BluetoothClassic();
  bool isScanning = false;
  bool isConnected = false;


  Future<bool> sendData() async {
    await _bluetoothConexion.initPermissions();
    await _bluetoothConexion.startScan();
    await _bluetoothConexion.onDeviceDiscovered().forEach((element) async {
      if (element.name == "PillStation") {
        await _bluetoothConexion.connect(
            element.address, "00001101-0000-1000-8000-00805F9B34FB");
        isConnected = true;
        await _bluetoothConexion.stopScan(); 
      }
    });
    return isConnected;
  }
}