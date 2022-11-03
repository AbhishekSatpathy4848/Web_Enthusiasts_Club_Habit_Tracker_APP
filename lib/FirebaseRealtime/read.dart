import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

List<DateTime> _convertToList(String string) {
  if (string == '[]') return [];
  List<DateTime> completedDays = [];
  string = string.substring(0, 1) + ' ' + string.substring(1);
  // print(string);
  int l = 0, r = 25;
  while (string[l] != ']') {
    if (string[l] == ',' || string[l] == '[') {
      l += 2;
    }
    // print(l.toString() + r.toString());
    // print(string.substring(l, r));
    completedDays.add(DateTime.parse(string.substring(l, r)));
    l = r;
    r = r + 25;
  }
  return completedDays;
}

void read(String type) {
  print("Entered read");
  try {
    print("reading $type");
    FirebaseDatabase.instance
        .ref()
        // .child(FirebaseAuth.instance.currentUser!.uid)
        // .child('CurrentHabits')
        .onValue
        .listen((event) {
      // print(event.snapshot
      //     .child(FirebaseAuth.instance.currentUser!.uid)
      //     .child(type)
      //     .children
      //     .length);
      if (FirebaseAuth.instance.currentUser == null) return;
      for (DataSnapshot dataSnapshot in event.snapshot
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(type)
          .children) {
        // print("asdas");
        // print(_convertToSet(json.decode(json
        //     .encode(dataSnapshot.child('completedDays').value.toString()))));
        Habit habit = Habit(
            dataSnapshot.child('name').value.toString(),
            Color(int.parse(
                dataSnapshot
                    .child('color')
                    .value
                    .toString()
                    .split('(0x')[1]
                    .split(')')[0],
                radix: 16)),
            DateTime.parse(
                dataSnapshot.child('streakStartDate').value.toString()),
            DateTime.parse(
                dataSnapshot.child('habitStartDate').value.toString()),
            int.parse(dataSnapshot.child('streaks').value.toString()),
            int.parse(dataSnapshot.child('maxStreaks').value.toString()),
            int.parse(dataSnapshot.child('goal').value.toString()),
            // dataSnapshot.child('completedDays').value as List<DateTime>,
            _convertToList(
                dataSnapshot.child('completedDays').value.toString()),
            DateTime.parse(
                dataSnapshot.child('bestStreakDate').value.toString()));
        // final box = Boxes.getHabits();
        // print(habit.name);
        // Hive.box<Habit>(type).add(habit);
        Hive.box<Habit>(type).put(habit.name, habit);
      }
    });
  } catch (e) {
    print("Read threw error");
  }
}

void readFromDatabase() {
  try {
    print("Enter read");
    print("reading from here");
    read("habits");
    read("completedHabits");
    print("Left read");
  } catch (e) {
    print("here here read.dart");
  }
}
