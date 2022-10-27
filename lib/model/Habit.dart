import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'Habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  Color? color;
  @HiveField(2)
  DateTime? streakStartDate;
  @HiveField(3)
  DateTime? habitStartDate;
  // Duration? end;
  @HiveField(4)
  int streaks;
  @HiveField(5)
  int maxStreaks;
  @HiveField(6)
  int goalDays;
  @HiveField(7)
  List<DateTime> completedDays;

  // double? successRate;
  // double? progressRate;

  // Habit(String name, Duration start, Duration end, int streaks,
  // double successRate, double progressRate) {
  Habit(this.name, this.color, this.streakStartDate,this.habitStartDate, this.streaks, this.maxStreaks,
      this.goalDays, this.completedDays);

  addToCompletedDays(DateTime dateTime) {
    completedDays.add(dateTime);
  }
}
