
import 'package:hive/hive.dart';
import 'package:local_db_flutter/user_model.dart';

class HiveMethods {
  String hiveBox = 'hive_local_db';

  Future<int> getNextId() async {
    var box = await Hive.openBox(hiveBox);
    int nextId = box.values.isEmpty ? 1 : (box.keys.reduce((a, b) => a > b ? a : b)) + 1;
    return nextId;
  }
  //Adding user model to hive db
  Future<void> addUser(UserModel userModel) async {
    int id = await getNextId(); // Get the next available ID
    var box = await Hive.openBox(hiveBox); //open the hive box before writing
    var mapUserData = userModel.toMap(userModel);
    await box.put(id, mapUserData);
    await Hive.close(); //closing the hive box
  }

  //Reading all the users data
  Future<List<UserModel>> getUserLists() async {
    var box = await Hive.openBox(hiveBox);
    List<UserModel> users = [];

    for (int i = box.length - 1; i >= 0; i--) {
      var userMap = box.getAt(i);
      users.add(UserModel.fromMap(Map.from(userMap)));
    }
    return users;
  }

  //Deleting one data from hive DB
  deleteUser(int id) async {
    var box = await Hive.openBox(hiveBox);
    await box.deleteAt(id);
  }

  //Deleting whole data from Hive
  deleteAllUsers() async {
    var box = await Hive.openBox(hiveBox);
    await box.clear();
  }
}
