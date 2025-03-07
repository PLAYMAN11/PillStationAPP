import 'package:mongo_dart/mongo_dart.dart';

class Mongodb{
  late Db db;
late DbCollection collection;

Future<void> connectDB() async {
  db = await Db.create("mongodb+srv://regina:pKW6Ir1kXLapHf5u@pillstation.c4ue9.mongodb.net/PillStation?retryWrites=true&w=majority&appName=PillStation");
  await db.open();
}
  void setcollection() {
  collection = db.collection("users");
  }
  Future<List<Map<String, dynamic>>> findUser() async {
  return await collection.find(where.excludeFields(["_id"])).toList();
  }
  
}
Mongodb mongodb = Mongodb();