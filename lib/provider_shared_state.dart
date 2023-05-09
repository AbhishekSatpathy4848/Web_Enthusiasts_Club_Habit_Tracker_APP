import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedState extends ChangeNotifier {
  String? lastBackedUp;

  set setLastBackedUp(String dateTime) {
    lastBackedUp = dateTime;
    notifyListeners();
  }

   SharedState({this.lastBackedUp});
}
