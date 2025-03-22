import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';
import 'package:pillstationmovil/config/mongodb.dart';

Bluetooth bluetooth = Bluetooth();
class Bluetooth {
  final _bluetoothConexion = BluetoothClassic();
  bool isScanning = false;
  bool isConnected = false;

  int size=0;
  Stream<String>? pillCode;

  // Add a completer to handle the async operation
  Completer<bool>? _connectionCompleter;

  Future<bool> sendData(String data) async {
    try {
      pillCode = null;
      isConnected = false; // Reset connection state

      // Create a new completer for this connection attempt
      _connectionCompleter = Completer<bool>();

      await _bluetoothConexion.initPermissions();
      await _bluetoothConexion.startScan();
      print("BUSCANDO");

      // Set up the device discovery subscription
      var subscription = _bluetoothConexion.onDeviceDiscovered().listen((element) async {
        print((element.name));
        if (element.name == "PillStation") {
          print("Encontrado");
          try {
            await _bluetoothConexion.connect(
                element.address, "00001101-0000-1000-8000-00805F9B34FB");
            print("Conectado");

            String tmp = "67da89a276c65ed1be22e62b";
            bool authenticated = await db.validateUser(tmp);
            if(authenticated) {
              print("datos enviados");
              await _bluetoothConexion.write(data);
              isConnected = true;

              // Complete the future with success
              if (!_connectionCompleter!.isCompleted) {
                _connectionCompleter!.complete(true);
              }
            } else {
              print("No esta autorizado para el acceso a este pastillero");
              // Complete with failure if not authenticated
              if (!_connectionCompleter!.isCompleted) {
                _connectionCompleter!.complete(false);
              }
            }
          } catch (e) {
            print("Error connecting to device: $e");
            // Complete with failure on error
            if (!_connectionCompleter!.isCompleted) {
              _connectionCompleter!.complete(false);
            }
          } finally {
            await _bluetoothConexion.stopScan();
          }
        }
      });
      Timer(Duration(seconds: 15), () {
        if (!_connectionCompleter!.isCompleted) {
          _connectionCompleter!.complete(false);
          _bluetoothConexion.stopScan();
          subscription.cancel();
          print("Scan timeout - no PillStation found");
        }
      });
      
      return await _connectionCompleter!.future;
    } catch (e) {
      print("Error in sendData: $e");
      return false;
    }
  }

  void closeConnection(){
    _bluetoothConexion.disconnect();
    isConnected=false;
    isScanning=false;
    pillCode=null;
  }
}