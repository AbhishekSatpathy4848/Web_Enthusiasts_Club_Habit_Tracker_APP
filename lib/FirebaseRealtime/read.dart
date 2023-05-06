import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

List<DateTime> _convertToList(String string) {
  if (string == '[]') return [];
  List<DateTime> completedDays = [];
  string = '${string.substring(0, 1)} ${string.substring(1)}';
  int l = 0, r = 25;
  while (string[l] != ']') {
    if (string[l] == ',' || string[l] == '[') {
      l += 2;
    }
    completedDays.add(DateTime.parse(string.substring(l, r)));
    l = r;
    r = r + 25;
  }
  return completedDays;
}

void read(String type) {
  try {
    FirebaseDatabase.instance
        .ref()
        .onValue
        .listen((event) {
      if (FirebaseAuth.instance.currentUser == null) return;
      for (DataSnapshot dataSnapshot in event.snapshot
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(type)
          .children) {
        Habit habit = Habit(
          name: dataSnapshot.child('name').value.toString(),
          color: Color(int.parse(
                dataSnapshot
                    .child('color')
                    .value
                    .toString()
                    .split('(0x')[1]
                    .split(')')[0],
                radix: 16)),
              
            streakStartDate: DateTime.parse(
                dataSnapshot.child('streakStartDate').value.toString()),
            habitStartDate: DateTime.parse(
                dataSnapshot.child('habitStartDate').value.toString()),
            streaks:  int.parse(dataSnapshot.child('streaks').value.toString()),
            maxStreaks: int.parse(dataSnapshot.child('maxStreaks').value.toString()),
            goalDays: int.parse(dataSnapshot.child('goal').value.toString()),
            completedDays: _convertToList(
                dataSnapshot.child('completedDays').value.toString()),
            bestStreakStartDate:  DateTime.parse(
                dataSnapshot.child('bestStreakDate').value.toString()),
              successRate:
                int.parse(dataSnapshot.child('successRate').value.toString()),
              progressRate:
                int.parse(dataSnapshot.child('progressRate').value.toString()));

        Hive.box<Habit>(type).put(habit.name, habit);
      }
    });
  } catch (e) {
    print("Read threw error");
  }
}

void readFromDatabase() {
  try {
    read("habits");
    read("completedHabits");
  } catch (e) {
    print("Error while reading from Firebase");
  }
}