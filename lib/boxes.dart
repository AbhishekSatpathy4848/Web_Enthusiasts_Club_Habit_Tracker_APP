import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/FirebaseRealtime/read.dart';
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

  static Box<Habit> getHabits() {
    print("Accessing Boxes1");
    String? result;
    FirebaseDatabase.instance.ref().onValue.listen((event) {
      result = event.snapshot
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('Signed out')
          .value
          .toString();
       
       if (result == 'true') {
          print("First time database");
          readFromDatabase();
          FirebaseDatabase.instance
              .ref()
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child('Signed out')
              .set('false');
    }

    });

    return Hive.box<Habit>('habits');
  }

  static Box<Habit> getCompletedHabits() {
    print("Accessing Boxes");

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
