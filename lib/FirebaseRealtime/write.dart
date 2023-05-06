import 'package:firebase_database/firebase_database.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/provider_shared_state.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> writeToDatabase(currentUID, context) async {
  print("writing to firebase");
  List<Habit> habitList = Hive.box<Habit>('habits').values.toList();
  List<Habit> completedHabitList =
      Hive.box<Habit>('completedHabits').values.toList();
  final database = FirebaseDatabase.instance.ref();

  try {
    await database.child(currentUID).remove();
  } catch (e) {
    print("Error in deleting from Firebase $e");
  }

  try {
    for (Habit habit in habitList) {
      await database
          .child(currentUID)
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
        "bestStreakDate": habit.bestStreakStartDate.toString(),
        "successRate": habit.successRate,
        "progressRate": habit.progressRate
      });
    }

    for (Habit habit in completedHabitList) {
      final database = FirebaseDatabase.instance.ref();
      await database
          .child(currentUID)
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
    final provider = Provider.of<SharedState>(context, listen: false);
    provider.setLastBackedUp =
        DateFormat('dd-MMMM-yyyy – hh:mm a').format(DateTime.now());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastBackUpDate', provider.lastBackedUp ?? "Not Backed Up");

    return true;
  } catch (e) {
    rethrow;
  }
}
