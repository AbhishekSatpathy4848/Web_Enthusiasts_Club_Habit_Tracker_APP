import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
// import 'package:habit_tracker/pages/HabitSet.dart';

void writeToDatabase(currrentUID) async {
  print("Entered write");
  List<Habit> habitList = Hive.box<Habit>('habits').values.toList();
  List<Habit> completedHabitList = Hive.box<Habit>('completedHabits').values.toList();
  final database = FirebaseDatabase.instance.ref();
  print("Entered write2");

  print(currrentUID);

  try {
    await database.child(currrentUID).remove();
  } catch (e) {
    print("Error in deleting from Firebase");
  }

  try {
    // await database.child(currrentUID).child("Signed out").set("true");
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
    // await Hive.close();
    // await Hive..delete(key)
    // await Hive.deleteFromDisk();
    // final box1 = ;
    // final box2 = Hive.box("completedHabits");
    // await Boxes.getHabits().deleteAll(Boxes.getHabits().keys);
    // await box2.deleteAll(box2.keys);
    print("Before clearing");
    await Hive.box<Habit>('habits').clear();
    await Hive.box<Habit>('completedHabits').clear();
    print("Before closing");
    await Hive.close();
    print("After closing");
    await Hive.deleteFromDisk().then((value) => print("box has been deleted"));
    print("After deleting");
    // await box2.close();
    // await Hive.box("habits").deleteFromDisk();
    // await box2.deleteFromDisk();
    print("is habits box open? ${Hive.isBoxOpen('habits')}");
    // print(Hive.isBoxOpen( "completedHabits"));
    bool ans = await Hive.boxExists("habits");
    print("does box exits? ${await Hive.boxExists("habits")}");
    // print(Hive.boxExists("completedHabits"));
  } catch (e) {
    print(e.toString());
    print("Write threw an error");
  }
}
