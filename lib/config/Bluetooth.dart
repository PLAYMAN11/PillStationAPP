
import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';

Bluetooth bluetooth = Bluetooth();
class Bluetooth{
  final bluetoothConexion = BluetoothClassic();
  Future<void> connect() async {
    await bluetoothConexion.initPermissions();
    List<Device> _discoveredDevices = await bluetoothConexion.getPairedDevices();
    for(Device device in _discoveredDevices){
      if (device.name == "PillStation") {
        await bluetoothConexion.connect(device.address, "00001101-0000-1000-8000-00805F9B34FB");
        bluetoothConexion.write("Conectado");
      }  
    }
  }
}
