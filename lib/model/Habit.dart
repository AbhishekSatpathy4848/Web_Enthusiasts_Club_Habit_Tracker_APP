import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/getDayDifference.dart';
part 'Habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  Color color;
  @HiveField(2)
  DateTime streakStartDate;
  @HiveField(3)
  DateTime habitStartDate;
  // Duration? end;
  @HiveField(4)
  int streaks;
  @HiveField(5)
  int maxStreaks;
  @HiveField(6)
  int goalDays;
  @HiveField(7)
  List<DateTime> completedDays;
  @HiveField(8)
  DateTime bestStreakStartDate;

  // double? successRate;
  // double? progressRate;

  // Habit(String name, Duration start, Duration end, int streaks,
  // double successRate, double progressRate) {
  Habit(this.name, this.color, this.streakStartDate,this.habitStartDate, this.streaks, this.maxStreaks,
      this.goalDays, this.completedDays,this.bestStreakStartDate);

  addToCompletedDays(DateTime dateTime) {
    completedDays.add(dateTime);
  }

  int getSuccessRate() {
    // print(habit.completedDays.length);
    // print(daysBetween(habit.habitStartDate!,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day +1)).toString());
    return ((completedDays.length /
                (daysBetween(
                        habitStartDate,
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)) +
                    1)) *
            100)
        .round();
  }

  int getProgressRate() {
    // if(habit.completedDays.length == 1){
    //     return ((1 / habit.goalDays) * 100).round();
    // }

    print(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (completedDays.contains(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      print("here");
      return (((daysBetween(
                          habitStartDate,
                          DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day)) +
                      1) /
                  goalDays) *
              100)
          .round();
    }
    print("here1");
    return (((daysBetween(
                    habitStartDate,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day))) /
                goalDays) *
            100)
        .round();
  }

  void editHabitStreaks(int streaks) {
    this.streaks = streaks;
    // print(habit.streaks);
    // habit.save();
  }

  void registerDay(DateTime currentDate) {
    completedDays.add(currentDate);
    // habit.save();
  }

  bool ishabitAlreadyRegisteredForTheDay(DateTime currentDate) {
    // return daysBetween(habit.streakStartDate!, currentDate) > habit.streaks;
    return completedDays.contains(currentDate);
  }

  void updateMaxStreak(int maxStreaks) {
    this.maxStreaks = maxStreaks;
    // print(habit.streaks);
    // habit.save();
  }

  void editHabitStreakBeginDate(DateTime currentDate) {
    streakStartDate = currentDate;
    // print(habit.streaks);
    // habit.save();
  }

}
