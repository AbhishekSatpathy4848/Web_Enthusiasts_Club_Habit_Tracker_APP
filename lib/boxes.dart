import 'package:habit_tracker/FirebaseRealtime/read.dart';

//update the local storage hive with data from the database
class Boxes {
  static Future fillHive() async {
    await readFromDatabase();
    return Future.value();
  }
}
