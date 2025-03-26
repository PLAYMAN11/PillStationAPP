import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:pillstationmovil/config/mongodb.dart';

Bluetooth bluetooth = Bluetooth();
class Bluetooth {
  final _bluetoothConexion = BluetoothClassic();
  bool isScanning = false;
  bool isConnected = false;

  int size=0;
  Stream<String>? pillCode;
  
  Completer<bool>? _connectionCompleter;

  Future<bool> sendData(String data) async {
    isConnected = false;
    pillCode = null;

    try {
      await _bluetoothConexion.stopScan();
    } catch (e) {
      print("Error stopping previous scan: $e");
    }

    final completer = Completer<bool>();
    StreamSubscription? subscription;

    // Set a timeout
    final timeoutTimer = Timer(Duration(seconds: 20), () {
      if (!completer.isCompleted) {
        subscription?.cancel();
        _bluetoothConexion.stopScan();
        completer.complete(false);
        print("Connection attempt timed out");
      }
    });

    try {
      // Catch the first PillStation device
      subscription = _bluetoothConexion.onDeviceDiscovered()
          .where((device) => device.name == "PillStation")
          .take(1)
          .listen((device) async {
        try {
          // Stop the scan immediately after finding the device
          await _bluetoothConexion.stopScan();

          // Connect to the device
          await _bluetoothConexion.connect(
              device.address, "00001101-0000-1000-8000-00805F9B34FB");
          print("Conectado a ${device.name}");

          // Validate user
          String tmp = "67da89a276c65ed1be22e62b";
          bool authenticated = await db.validateUser(tmp);

          if (authenticated) {
            // Send data
            await _bluetoothConexion.write(data);
            isConnected = true;

            if (!completer.isCompleted) {
              completer.complete(true);
            }
          } else {
            print("No autorizado");
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          }
        } catch (e) {
          print("Connection error: $e");
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        } finally {
          await subscription?.cancel();
        }
      }, onError: (error) {
        print("Stream error: $error");
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      }, cancelOnError: true);

      // Initialize scan
      await _bluetoothConexion.initPermissions();
      await _bluetoothConexion.startScan();
      print("BUSCANDO dispositivos...");

      // Wait for connection result
      bool result = await completer.future;

      // Cancel timeout timer
      timeoutTimer.cancel();

      return result;
    } catch (e) {
      print("Fatal error in sendData: $e");
      timeoutTimer.cancel();
      return false;
    } finally {
      // Ensure scan is stopped
      try {
        await _bluetoothConexion.stopScan();
      } catch (_) {}
    }
  }

  void closeConnection(){
    _bluetoothConexion.disconnect();
    isConnected=false;
    isScanning=false;
    pillCode=null;
  }
  void resetConnectionState() {
    isScanning = false;
    isConnected = false;
    pillCode = null;
    _connectionCompleter = null;
  }
}