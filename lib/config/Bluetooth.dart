import 'dart:async';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'mongodb.dart';

Bluetooth bluetooth = Bluetooth();
class Bluetooth {
  final BluetoothClassic _bluetoothConexion = BluetoothClassic();
  bool isConnected = false;
  bool isScanning = false;
  int size = 0;
  Stream<String>? pillCode;

  Future<bool> sendData(String data, {int maxRetries = 3}) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        
        closeConnection();
        // Stop any ongoing scan
        await _bluetoothConexion.stopScan();

        // Create a new stream for each attempt
        final deviceStream = _bluetoothConexion.onDeviceDiscovered()
            .where((device) => device.name == "PillStation")
            .take(1)
            .asBroadcastStream(); // Make the stream reusable

        final completer = Completer<bool>();
        StreamSubscription? subscription;
        bool isCompleted = false;

        // Timeout timer
        final timeoutTimer = Timer(Duration(seconds: 20), () {
          if (!isCompleted) {
            subscription?.cancel();
            _bluetoothConexion.stopScan();
            print("Connection attempt $attempt timed out");
            completer.complete(false);
            isCompleted = true;
          }
        });

        // Single subscription to handle device discovery
        subscription = deviceStream.listen((device) async {
          try {
            await _bluetoothConexion.stopScan();

            await _bluetoothConexion.connect(
                device.address,
                "00001101-0000-1000-8000-00805F9B34FB"
            );

            print("Connected to ${device.name}");

            // Your validation logic
            String tmp = "67da89a276c65ed1be22e62b";
            bool authenticated = await db.validateUser(tmp);

            if (authenticated) {
              Future.delayed(Duration(seconds: 1));
              await _bluetoothConexion.write(data);
              isConnected = true;
              if (!isCompleted) {
                completer.complete(true);
                isCompleted = true;
              }
            } else {
              print("Not authorized");
              if (!isCompleted) {
                completer.complete(false);
                isCompleted = true;
              }
            }
          } catch (e) {
            print("Connection attempt $attempt error: $e");
            if (!isCompleted) {
              completer.complete(false);
              isCompleted = true;
            }
          } finally {
            subscription?.cancel();
          }
        }, onError: (error) {
          print("Stream error in attempt $attempt: $error");
          if (!isCompleted) {
            completer.complete(false);
            isCompleted = true;
          }
        }, cancelOnError: true);

        // Start new scan
        await _bluetoothConexion.initPermissions();
        await _bluetoothConexion.startScan();
        print("Scanning for devices... (Attempt ${attempt + 1})");

        bool result = await completer.future;
        timeoutTimer.cancel();

        if (result) {
          return true; // Success, exit retry loop
        }
      } catch (e) {
        print("Fatal error in sendData attempt $attempt: $e");
      } finally {
        try {
          await _bluetoothConexion.stopScan();
        } catch (_) {}
      }

      // Wait a bit before retrying
      await Future.delayed(Duration(seconds: 2));
    }

    return false; 
  }

  void closeConnection() {
    _bluetoothConexion.disconnect();
    isConnected = false;
    isScanning = false;
    pillCode = null;
  }

  void resetConnectionState() {
    isScanning = false;
    isConnected = false;
    pillCode = null;
  }
}