import 'package:pillstationmovil/config/mongodb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Query extends StatefulWidget {

  const Query({Key? key}) : super(key: key);

  @override
  _QueryState createState() => _QueryState();
}

class _QueryState extends State<Query> {

  List<Map<String, dynamic>> results=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultar();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
        body: Builder(builder: (context) {
          if (results.isEmpty) {
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Card(
                  child: CupertinoListTile(title: Text("${results[index]}", style: TextStyle(color: Colors.white, ),)),
                );
              }
          );
        }
        )
    );
  }
  Future<void> consultar() async {
    await db.connectDB();
    db.setcollectionUser();
    results = await db.findUser();
    setState(() {
      print("Results: $results");
    });
  }
}