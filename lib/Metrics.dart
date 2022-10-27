import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/getDayDifference.dart';

class Metrics {
  static int getSuccessRate(Habit habit) {
    return ((habit.completedDays.length / (daysBetween(habit.habitStartDate!, DateTime.now()) + 1)) * 100).round();
  }
  static int getProgressRate(Habit habit){
    return (((daysBetween(habit.habitStartDate!, DateTime.now()) + 1) / habit.goalDays) * 100).round();
  }
}
