import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillstationmovil/config/Bluetooth.dart';
import 'package:pillstationmovil/config/pill.dart';

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> with SingleTickerProviderStateMixin {
  String? datos;
  bool _isConnecting = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    DateTime date = DateTime.now();
    List<int> hours=[];
    List<int> minutes=[];
    int i=0;
    print(hours);
    if (date.minute+2 >= 60) {
      minutes.add(date.minute+2%60);
      hours.add(date.hour+1);
    } else{
      minutes.add(date.minute+2);
      hours.add(date.hour);
    }
    datos = "{hour : $hours, minutes:$minutes}";
    print("${datos}");

    // Start the connection process
    SendData();

    // Add a delayed check to update UI after connection
    Future.delayed(const Duration(seconds: 3), () {
      checkConnectionStatus();
    });
  }

  void checkConnectionStatus() {
    if (mounted) {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force refresh the UI based on bluetooth.isConnected
    final bool isConnected = bluetooth.isConnected;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.medication, size: 30, color: Colors.blue),
            ),
            const SizedBox(width: 8),
            const Text(
              'PillStation',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.blue),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ayuda de Conexión'),
                  content: const Text('Asegúrese que su dispositivo PillStation esté encendido y en modo de emparejamiento. El LED azul debe estar parpadeando.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Connection status card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _isConnecting
                                ? "Conectando al dispositivo"
                                : isConnected
                                ? "Conexión exitosa"
                                : "Error de conexión",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          _isConnecting
                              ? _buildConnectingIndicator()
                              : isConnected
                              ? _buildSuccessIndicator()
                              : _buildErrorIndicator(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Instructions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Instrucciones de conexión",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInstructionStep(
                            1,
                            "Asegúrese de haber habilitado el Bluetooth en su dispositivo móvil",
                            Icons.bluetooth,
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionStep(
                            2,
                            "Encienda su PillStation y espere a que el LED azul parpadee",
                            Icons.power_settings_new,
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionStep(
                            3,
                            "Mantenga su dispositivo cerca del PillStation durante la conexión",
                            Icons.phonelink_ring,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                  ],
                ),
              ),
            ),

            // Bottom action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isConnected ? null : () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.blue.shade700),
                      ),
                      child: Text(
                        "Volver",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isConnecting ? null : () {
                        if (!isConnected) {
                          setState(() {
                            _isConnecting = true;
                          });

                          // Try to connect again
                          SendData();

                          // Check connection status after a delay
                          Future.delayed(const Duration(seconds: 3), () {
                            checkConnectionStatus();
                          });
                        } else {
                          // Continue to next screen
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isConnected ? "Continuar" : "Reintentar",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "Buscando dispositivo...",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.green,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "Datos Enviados",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.red,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "No se pudo conectar",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(int step, String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Icon(
          icon,
          color: Colors.blue.shade700,
          size: 24,
        ),
      ],
    );
  }

  Future<void> SendData() async {
    try {
      await bluetooth.sendData(datos!);

      // Explicitly set bluetooth.isConnected to true if needed
      // This depends on how your bluetooth class is implemented
      // If bluetooth.sendData() already sets isConnected, you can skip this

      // Update the UI state after data is sent
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    } catch (e) {
      print("Error sending data: $e");

      // Update UI to show error state
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }
}