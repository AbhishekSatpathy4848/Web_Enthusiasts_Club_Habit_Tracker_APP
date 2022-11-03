import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/FirebaseRealtime/read.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

//update the local storage hive with data from the database

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

  static fillHive() {
    print("Started filling hive");

    readFromDatabase();

    // Hive.boxExists("habits").then((value) => print("box exits $value"));
    // String? result;
    // FirebaseDatabase.instance.ref().onValue.listen((event) {
      // print("-1");
      // result = event.snapshot
      //     .child(FirebaseAuth.instance.currentUser!.uid)
      //     .child('Signed out')
      //     .value
      //     .toString();
      // print("-2");
      // if (result == 'true') {
      //   print("First time database");
      //   print("-3");
        // readFromDatabase();
        // print("-4");
        // FirebaseDatabase.instance
        //     .ref()
        //     .child(FirebaseAuth.instance.currentUser!.uid)
        //     .child('Signed out')
        //     .set('false');
        // print("-5");
      // }
      // print("-6");
    // });
    // });
    // print("-6");

    // return Hive.box<Habit>('habits');
    print("Finished Filling Hive");
  }

  // static Box<Habit> getCompletedHabits() {
  //   print("Accessing Box 2");

  //   return Hive.box<Habit>('completedHabits');
  // }

  // static Future<Box<Habit>> getHabits() async {
  //   await Hive.openBox<Habit>('habits');
  //   return Hive.box<Habit>('habits');
  // }
  // static Future<Box<Habit>> getCompletedHabits() async {
  //   await Hive.openBox<Habit>('completedHabits');
  //   return Hive.box<Habit>('completedHabits');
  // }
}
