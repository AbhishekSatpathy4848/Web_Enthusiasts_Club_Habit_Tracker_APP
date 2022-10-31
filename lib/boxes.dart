import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Boxes {
  // static Future openHabits() async {
  //   print("opening habits");
  //   await Hive.openBox<Habit>('habits');
  //   returnHive.box<Habit>('completedHabits');
  //   // print("Done");
  // }

  // static Future openCompletedHabits() async {
  //   print("opening completed habits");
  //   await Hive.openBox<Habit>('completedHabits');
  // }

  static List<DateTime> _convertToList(String string) {
    List<DateTime> completedDays = [];
    string = string.substring(0, 1) + ' ' + string.substring(1);
    print(string);
    int l = 0, r = 25;
    while (string[l] != ']') {
      if (string[l] == ',' || string[l] == '[') {
        l += 2;
      }
      print(l.toString() + r.toString());
      print(string.substring(l, r));
      completedDays.add(DateTime.parse(string.substring(l, r)));
      l = r;
      r = r + 25;
    }
    return completedDays;
  }

  static Box<Habit> getHabits() {
    // print("Accessing Boxes1");
    // Hive.openBox<Habit>('habits');
    // FirebaseDatabase.instance
    //     .ref()
    //     .child(FirebaseAuth.instance.currentUser!.uid)
    //     .child('CurrentHabits')
    //     .onValue
    //     .listen((event) {
    //   for (DataSnapshot dataSnapshot in event.snapshot.children) {
    //     print("asdas");
    //     print(_convertToList(json.decode(json
            // .encode(dataSnapshot.child('completedDays').value.toString()))));
            // Habit habit = Habit(
            //     dataSnapshot.child('name').value.toString(),
            //     Color(int.parse(
            //         dataSnapshot
            //             .child('color')
            //             .value
            //             .toString()
            //             .split('(0x')[1]
            //             .split(')')[0],
            //         radix: 16)),
            //     DateTime.parse(
            //         dataSnapshot.child('streakStartDate').value.toString()),
            //     DateTime.parse(
            //         dataSnapshot.child('habitStartDate').value.toString()),
            //     int.parse(dataSnapshot.child('streaks').value.toString()),
            //     int.parse(dataSnapshot.child('maxStreaks').value.toString()),
            //     int.parse(dataSnapshot.child('goal').value.toString()),
            //     // dataSnapshot.child('completedDays').value as List<DateTime>,
            //     _convertToList(json.decode(json
            // .encode(dataSnapshot.child('completedDays').value.toString()))),
            //     DateTime.parse(
            //         dataSnapshot.child('bestStreakDate').value.toString()));
            // final box = Boxes.getHabits();
            // print(habit.name);
            // Hive.box<Habit>('habits').add(habit);
    //   }
    // });

    return Hive.box<Habit>('habits');
  }

  static Box<Habit> getCompletedHabits() {
    print("Accessing Boxes");
    // FirebaseDatabase.instance
    //     .ref()
    //     .child(FirebaseAuth.instance.currentUser!.uid)
    //     .child('CompletedHabits');
    return Hive.box<Habit>('completedHabits');
  }

  // static Future<Box<Habit>> getHabits() async {
  //   await Hive.openBox<Habit>('habits');
  //   return Hive.box<Habit>('habits');
  // }
  // static Future<Box<Habit>> getCompletedHabits() async {
  //   await Hive.openBox<Habit>('completedHabits');
  //   return Hive.box<Habit>('completedHabits');
  // }
}
