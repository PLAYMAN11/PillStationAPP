import 'package:flutter/material.dart';
import 'package:pillstationmovil/config/pill.dart';
import 'package:pillstationmovil/widgets/pillbox/add_pill.dart';
import 'package:pillstationmovil/widgets/pillbox/connectPillbox.dart';

import '../../config/mongodb.dart';

class ConfigurePillbox extends StatefulWidget {
  const ConfigurePillbox({Key? key}) : super(key: key);

  @override
  _ConfigurePillboxState createState() => _ConfigurePillboxState();
}

class _ConfigurePillboxState extends State<ConfigurePillbox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDB();
  }

  @override
  Widget build(BuildContext context) {
    return db.isloaded
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              toolbarHeight: 120,
              title: Text(
                "Aliste las pastillas",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: pillList.length,
              itemBuilder: (context, index) {
                if (pillList.isEmpty) {
                  return Center(
                      child: Text(
                    "No hay datos",
                    style: TextStyle(fontSize: 20),
                  ));
                } else {
                  return ListTile(
                    title: Text(
                      pillList.elementAt(index).name,
                    ),
                    subtitle: Text(
                        "Cada ${pillList.elementAt(index).hour} horas"),
                  );
                }
              },
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddPill()));
                      },
                      icon: Icon(
                        Icons.add,
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
                                builder: (context) => Connectpillbox()));
                      },
                      icon: Icon(Icons.check),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> startDB() async {
    await db.connectDB().whenComplete(
      () async {
        db.setcollectionPills();
        db.isloaded = true;
        List<Map<String, dynamic>> tmp = await db.findpills();
        db.results =
            tmp.map((item) => item["nombre_medicamento"] as String).toList();
        setState(() {});
      },
    );
  }
}
