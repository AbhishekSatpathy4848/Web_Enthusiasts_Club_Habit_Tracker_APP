import 'package:habit_tracker/getDayDifference.dart';
import 'package:habit_tracker/model/Habit.dart';

void updateStreakMetrics(Habit habit,DateTime currentDate) {
  if (daysBetween(habit.streakStartDate, currentDate) == habit.streaks) {
    // print("is it?"+ habit.ishabitAlreadyRegisteredForTheDay(currentDate).toString());

    // editHabitStreaks(habit, habit.streaks + 1);
    if (habit.ishabitAlreadyRegisteredForTheDay(currentDate)) {
      habit.editHabitStreaks(habit.streaks + 1);
    }

    if (habit.maxStreaks <= habit.streaks) {
      habit.updateMaxStreak(habit.streaks);
      habit.bestStreakStartDate = habit.streakStartDate;
      // habit.save();
    }
  } else if (daysBetween(habit.streakStartDate, currentDate) > habit.streaks) {
    // if (habit.ishabitAlreadyRegisteredForTheDay(currentDate)) {
      habit.editHabitStreakBeginDate(currentDate);

    // }
    // showCompletedAnimationDialog();
    habit.editHabitStreaks(0);
  }
  // habit.save();
}
