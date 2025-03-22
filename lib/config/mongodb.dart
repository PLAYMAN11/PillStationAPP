import 'dart:math';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:pillstationmovil/config/pill.dart';
import 'package:pillstationmovil/config/user.dart';

Mongodb db = Mongodb();

class Mongodb {
  bool isloaded = false;
  List<ObjectId> meds = [];
  List<String> results = [];

  late Db db;
  late DbCollection collection;

  Future<void> connectDB() async {
    db = await Db.create(
        "mongodb+srv://regina:pKW6Ir1kXLapHf5u@pillstation.c4ue9.mongodb.net/PillStation?retryWrites=true&w=majority&appName=PillStation");
    await db.open();
  }

  //Collections
  void setcollectionUser() {
    collection = db.collection("users");
  }

  void setcollectionPillbox() {
    collection = db.collection("Pastillero");
  }

  void setcollectionPills() {
    collection = db.collection("Medicamento");
  }

  void setcollectionNurses() {
    collection = db.collection("Enfermero");
  }

  Future<List<Map<String, dynamic>>> findUser() async {
    return await collection.find(where.excludeFields(["_id"])).toList();
  }

  Future<List<Map<String, dynamic>>> findpills() async {
    return await collection.find().toList();
  }

  Future<bool> Login(String name, String password) async {
    print("Cargando DB");
    await connectDB();
    print("cargando Coleccion enfermeros");
    setcollectionNurses();
    print("Procesando");
    List<Map<String, dynamic>> result =
        await collection.find(where.eq("username", name)).toList();
    if (result.isEmpty) {
      print("Es vacio");
      return false;
    }
    print("Si existe");
    nurse = user(result[0]["_id"], result[0]["name"]);
    return true;
  }

  Future<void> getMedsId(List<Pill> pillList) async {
    List<ObjectId> resultados = [];
    setcollectionPills();
    for (int i = 0; i < pillList.length; i++) {
      var result = await collection
          .find(where.eq("nombre_medicamento", pillList[i].name))
          .toList();
      print("Imprimiendo RESULTADO");
      print(result);
      if (result.isNotEmpty) {
        resultados.add(result[0]["_id"]);
      }
    }
    meds = resultados;
    print("MOSTRNADO TODOS LOS RESULTADOS");
    print(meds);
  }

  void closeConnection() {
    isloaded = false;
    results = [];
    meds = [];
    db.close();
  }

  Future<bool> validateUser(String pillCode) async {
    await connectDB();
    setcollectionPillbox();
    print("BUSCANDO AUTORIZACION");
    print("$pillCode");
    var pillObjectId = ObjectId.parse(pillCode);

    List<Map<String, dynamic>> dar = await collection
        .find(where.eq("_id", pillObjectId).all("enfermeros_autorizados", [nurse.ID])).toList();
    print("DAR: $dar");
    closeConnection();
    return dar.isNotEmpty;
  }
}
