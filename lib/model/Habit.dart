import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'Habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late Color color;
  // Duration? start;
  // Duration? end;
  // int? streaks;
  // double? successRate;
  // double? progressRate;

  // Habit(String name, Duration start, Duration end, int streaks,
  // double successRate, double progressRate) {
  Habit(this.name,this.color);
}
