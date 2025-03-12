import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pillstationmovil/config/mongodb.dart';
import 'package:pillstationmovil/config/pill.dart';
import 'package:pillstationmovil/widgets/pillbox/configure_pillbox.dart';

class AddPill extends StatefulWidget {
  const AddPill({Key? key}) : super(key: key);

  @override
  _AddPillState createState() => _AddPillState();
}

class _AddPillState extends State<AddPill> {
  List<int> hours = [];
  int? selectedFrequency;
  String? selectedPill;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hours = [2,4,6,8];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 120,
        title: Text(
          "Agregar Pastilla",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Pastilla",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 10)),
            DropdownSearch(
              onChanged: (value) {
                selectedPill = value;
              },
              compareFn: (item1, item2) {
                return false;
              },
              items: (filter, infiniteScrollProps) =>
                  db.results.isEmpty ? [] : db.results,
              autoValidateMode: AutovalidateMode.always,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                title: Text("Buscar"),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0)),
            Text(
              "Frecuencia",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
            Row(
              children: [
                DropdownButton2(
                    value: selectedFrequency,
                    onChanged: (int? value) {
                      setState(() {
                        selectedFrequency = value;
                      });
                    },
                    items: hours
                        .map((int item) => DropdownMenuItem<int>(
                            value: item,
                            child: Text(""+item.toString(),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                            )))
                        .toList()),
                Text("horas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
        child: Row(
          spacing: 110,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfigurePillbox()));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                color: Colors.black,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                onPressed: () {
                  pillList.add(Pill(selectedPill!, (selectedFrequency!),(0)));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfigurePillbox()));
                },
                icon: Icon(Icons.check),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
