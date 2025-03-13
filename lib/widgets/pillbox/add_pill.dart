import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pillstationmovil/config/mongodb.dart';
import 'package:pillstationmovil/config/pill.dart';
import 'package:pillstationmovil/widgets/pillbox/configure_pillbox.dart';

class AddPill extends StatefulWidget {
  const AddPill({Key? key}) : super(key: key);

  @override
  _AddPillState createState() => _AddPillState();
}

class _AddPillState extends State<AddPill> {
  final _formKey = GlobalKey<FormState>();
  List<int> hours = [2, 4, 6, 8];
  int? selectedFrequency;
  String? selectedPill;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _savePill() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      pillList.add(Pill(selectedPill!, selectedFrequency!, 0));
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConfigurePillbox()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        title: const Text(
          "Agregar Pastilla",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Pill selection card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pastilla",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownSearch<String>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "Buscar pastilla",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            menuProps: const MenuProps(
                              backgroundColor: Colors.white,
                            ),
                            title: Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: const Text(
                                "Seleccionar Pastilla",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          items: (filter, loadProps) => db.results,
                          onChanged: (value) {
                            setState(() {
                              selectedPill = value;
                            });
                          },
                          selectedItem: selectedPill,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione una pastilla';
                            }
                            return null;
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              hintText: "Seleccione una pastilla",
                              hintStyle: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,),
                              suffixStyle: TextStyle(),
                              counterStyle: TextStyle(color: Colors.white10),
                              alignLabelWithHint: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(16,0,0,0),
                              fillColor: Colors.grey[100]
                              


                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Frequency selection card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Frecuencia",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FormField<int>(
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor seleccione la frecuencia';
                            }
                            return null;
                          },
                          builder: (FormFieldState<int> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      value: selectedFrequency,
                                      hint: const Text("Seleccionar horas"),
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedFrequency = value;
                                          state.didChange(value);
                                        });
                                      },
                                      items: hours.map((int item) {
                                        return DropdownMenuItem<int>(
                                          value: item,
                                          child: Text(
                                            "Cada $item horas",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, left: 12),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Information card
                Card(
                  elevation: 0,
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "La pastilla será programada según la frecuencia seleccionada",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfigurePillbox()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Guardar",
                        style: TextStyle(
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
    );
  }
}
