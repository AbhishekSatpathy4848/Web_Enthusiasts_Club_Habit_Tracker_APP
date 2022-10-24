import 'package:hive/hive.dart';
part 'Habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject{
  @HiveField(0)
  String? name;
  // Duration? start;
  // Duration? end;
  // int? streaks;
  // double? successRate;
  // double? progressRate;
  
  // Habit(String name, Duration start, Duration end, int streaks,
      // double successRate, double progressRate) {
  Habit(String this.name);
}
