import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillstationmovil/config/pill.dart';
import '../../config/Bluetooth.dart';

class OrganizePills extends StatefulWidget {
  const OrganizePills({Key? key}) : super(key: key);

  @override
  _OrganizePillsState createState() => _OrganizePillsState();
}

class _OrganizePillsState extends State<OrganizePills> {
  // List to store medications for each compartment
  List<List<String>> compartmentMedications = [];

  @override
  void initState() {
    super.initState();

    // Initialize the compartment medications list
    for (int i = 0; i < bluetooth.size; i++) {
      compartmentMedications.add([]);
    }

    // Organize pills into compartments based on dosage frequency
    for (int i = 0; i < pillList.length; i++) {
      switch (pillList[i].hour) {
        case 2:
          for (int j = 0; j < bluetooth.size; j++) {
            compartmentMedications[j].add(pillList[i].name);
          }
          break;
        case 4:
          switch (bluetooth.size) {
            case 2:
              for (int j = 0; j < bluetooth.size; j++) {
                compartmentMedications[j].add(pillList[i].name);
              }
              break;
            case 4:
              for (int j = 1; j < bluetooth.size; j += 2) {
                compartmentMedications[j].add(pillList[i].name);
              }
              break;
            case 3:
              for (int j = 0; j < bluetooth.size; j += 2) {
                compartmentMedications[j].add(pillList[i].name);
              }
              break;
          }
          break;
        case 6:
          switch (bluetooth.size) {
            case 1:
              compartmentMedications[0].add(pillList[i].name);
              break;
            case 2:
              compartmentMedications[0].add(pillList[i].name);
              break;
            case 3:
              compartmentMedications[1].add(pillList[i].name);
              break;
            case 4:
              compartmentMedications[2].add(pillList[i].name);
              break;
          }
          break;
        case 8:
          switch (bluetooth.size) {
            case 1:
              compartmentMedications[0].add(pillList[i].name);
              break;
            case 2:
              compartmentMedications[1].add(pillList[i].name);
              break;
            case 4:
              compartmentMedications[3].add(pillList[i].name);
              break;
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: const Text(
          'Organizar Medicamentos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ayuda'),
                  content: const Text(
                    'Esta pantalla muestra cómo están organizados sus medicamentos en cada compartimento de su PillStation. Toque cada compartimento para ver los medicamentos asignados.',
                  ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribución de Medicamentos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${bluetooth.size} Compartimentos',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Compartment indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      bluetooth.size,
                          (index) => Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'Detalles de Compartimentos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: bluetooth.size,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          'Compartimento ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${compartmentMedications[index].length} medicamentos',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.blue[700],
                        ),
                        children: compartmentMedications[index].isEmpty
                            ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'No hay medicamentos asignados a este compartimento',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        ]
                            : compartmentMedications[index].map((medication) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.medication,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              medication,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            dense: true,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Exit the application
              SystemNavigator.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              "Salir",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}