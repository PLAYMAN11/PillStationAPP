import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pillstationmovil/config/mongodb.dart';
import 'package:pillstationmovil/widgets/pillbox/configure_pillbox.dart';

class AddPill extends StatefulWidget {
  const AddPill({Key? key}) : super(key: key);

  @override
  _AddPillState createState() => _AddPillState();
}

class _AddPillState extends State<AddPill> {

  @override
  void initState() {
    // TODO: implement initState
   
    super.initState();
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
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Text("Pastilla",),
          DropdownSearch(
            
            enabled: true,
            
            compareFn: (item1, item2) {
              return false;
            },
            items: (filter, infiniteScrollProps) => db.results.isEmpty ? [] : db.results,
            autoValidateMode: AutovalidateMode.always,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              title: Text("Buscar"),
            ),
          ),

        ],
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
