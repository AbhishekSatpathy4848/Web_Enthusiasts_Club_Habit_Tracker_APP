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
  @HiveField(9)
  int successRate = 0;
  @HiveField(10)
  int progressRate = 0;
  @HiveField(11)
  DateTime? dailyReminderTime;

  Habit(
      {required this.name,
      required this.color,
      required this.streakStartDate,
      required this.habitStartDate,
      this.streaks = 0,
      this.maxStreaks = 0,
      required this.goalDays,
      required this.bestStreakStartDate,
      required this.completedDays,
      this.successRate = 0,
      this.progressRate = 0,
      this.dailyReminderTime})
      : super();

  addToCompletedDays(DateTime dateTime) {
    completedDays.add(dateTime);
  }

  void updateSuccessRate() {
    successRate = ((completedDays.length /
                (daysBetween(
                        habitStartDate,
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)) +
                    1)) *
            100)
        .round();
    if (successRate > 100) {
      successRate = 100;
    }
  }

  void updateProgressRate() {
    if (completedDays.contains(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      progressRate = (((daysBetween(
                          habitStartDate,
                          DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day)) +
                      1) /
                  goalDays) *
              100)
          .round();
      if (progressRate > 100) {
        progressRate = 100;
      }
      return;
    }
    progressRate = (((daysBetween(
                    habitStartDate,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day))) /
                goalDays) *
            100)
        .round();
    if (progressRate > 100) {
      progressRate = 100;
    }
  }

  void editHabitStreaks(int streaks) {
    this.streaks = streaks;
  }

  void registerDay(DateTime currentDate) {
    completedDays.add(currentDate);
  }

  bool ishabitAlreadyRegisteredForTheDay(DateTime currentDate) {
    return completedDays.contains(currentDate);
  }

  void updateMaxStreak(int maxStreaks) {
    this.maxStreaks = maxStreaks;
  }

  void editHabitStreakBeginDate(DateTime currentDate) {
    streakStartDate = currentDate;
  }

  bool isCompleted() {
    if (progressRate >= 100) {
      return true;
    }
    return false;
  }
}
