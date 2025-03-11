import 'package:mongo_dart/mongo_dart.dart';

Mongodb db = Mongodb();

class Mongodb{
  bool isloaded =false;
  List<String> results =[];
  late Db db;
late DbCollection collection;

  void setcollectionUser() {
    collection = db.collection("users");
  }
  void setcollectionPills() {
    collection = db.collection("Medicamento");
  }
Future<void> connectDB() async {
  db = await Db.create("mongodb+srv://regina:pKW6Ir1kXLapHf5u@pillstation.c4ue9.mongodb.net/PillStation?retryWrites=true&w=majority&appName=PillStation");
  await db.open();
}
  Future<List<Map<String, dynamic>>> findUser() async {
  return await collection.find(where.excludeFields(["_id"])).toList();
  }
  Future <List<Map<String, dynamic>>> findpills() async{
  return await collection.find().toList();
}

}