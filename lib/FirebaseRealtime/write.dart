import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
// import 'package:habit_tracker/pages/HabitSet.dart';

void writeToDatabase(currrentUID) async {
  Set<Habit> habitList = Boxes.getHabits().values.toSet();
  Set<Habit> completedHabitList = Boxes.getCompletedHabits().values.toSet();
  final database = FirebaseDatabase.instance.ref();

  print(currrentUID);

  try {
    await database.child(currrentUID).remove();
  } catch (e) {
    print("Error in deleting from Firebase");
  }

  try {
    await database.child(currrentUID).child("Signed out").set("true");
    print(habitList.length);
    for (Habit habit in habitList) {
      await database
          .child(currrentUID)
          .child("habits")
          .child(database.push().key!)
          .set({
        "name": habit.name,
        "color": habit.color.toString(),
        "streakStartDate": habit.streakStartDate.toString(),
        "habitStartDate": habit.habitStartDate.toString(),
        "streaks": habit.streaks,
        "maxStreaks": habit.maxStreaks,
        "goal": habit.goalDays,
        "completedDays": habit.completedDays.toString(),
        "bestStreakDate": habit.bestStreakStartDate.toString()
      });
    }

    for (Habit habit in completedHabitList) {
      final database = FirebaseDatabase.instance.ref();
      await database
          .child(currrentUID)
          .child("completedHabits")
          .child(database.push().key!)
          .set({
        "name": habit.name,
        "color": habit.color.toString(),
        "streakStartDate": habit.streakStartDate.toString(),
        "habitStartDate": habit.habitStartDate.toString(),
        "streaks": habit.streaks,
        "maxStreaks": habit.maxStreaks,
        "goal": habit.goalDays,
        "completedDays": habit.completedDays.toString(),
        "bestStreakDate": habit.bestStreakStartDate.toString()
      });
    }
    Hive.close();
    Hive.deleteFromDisk();
  } catch (e) {
    print(e.toString());
    print("Write threw an error");
  }
}
