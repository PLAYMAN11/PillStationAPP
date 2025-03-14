import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';


Bluetooth bluetooth = Bluetooth();
class Bluetooth {
  final _bluetoothConexion = BluetoothClassic();
  bool isScanning = false;
  bool isConnected = false;
  int size=0;
  

  Future<bool> sendData(String data) async {
    await _bluetoothConexion.initPermissions();
    await _bluetoothConexion.startScan();
    print("BUSCANDO");
    await _bluetoothConexion.onDeviceDiscovered().forEach((element) async {
      print((element.name));
      if (element.name == "PillStation") {
        print("ENCONTRADO");
        await _bluetoothConexion.connect(
            element.address, "00001101-0000-1000-8000-00805F9B34FB");
        _bluetoothConexion.write(data);
        isConnected = true;
        await _bluetoothConexion.stopScan();
      }
    });
    return isConnected;
  }
}