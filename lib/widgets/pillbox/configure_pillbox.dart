import 'package:flutter/material.dart';
import 'package:pillstationmovil/widgets/pillbox/add_pill.dart';
import 'package:pillstationmovil/widgets/pillbox/connectPillbox.dart';

class ConfigurePillbox extends StatefulWidget {
  const ConfigurePillbox({Key? key}) : super(key: key);

  @override
  _ConfigurePillboxState createState() => _ConfigurePillboxState();
}

class _ConfigurePillboxState extends State<ConfigurePillbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
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
    );
  }
}
