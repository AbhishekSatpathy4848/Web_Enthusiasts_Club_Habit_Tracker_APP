import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';

class Boxes {
  static Box<Habit> getHabits() => Hive.box<Habit>('habits');
  static Box<Habit> getCompletedHabits() => Hive.box<Habit>('completedHabits');
}
