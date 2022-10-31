import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:habit_tracker/model/Habit.dart';

class calendar extends StatelessWidget {
  calendar(this.habit, {super.key});
  late Habit habit;

  @override
  Widget build(BuildContext context) {
    return CleanCalendar(
      datesForStreaks: habit.completedDays.toList(),
      // datePickerCalendarView: DatePickerCalendarView.weekView,
      currentDateProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
          // datesBackgroundColor: Colors.lightGreen.shade100,
          datesBorderColor: Colors.blue,
          // datesTextColor: Colors.black,
        ),
      ),
      generalDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
          datesBorderColor: Colors.amberAccent[200],
          // datesTextColor: Colors.white,
        ),
      ),
      streakDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
          datesBackgroundColor: const Color.fromRGBO(26, 26, 26, 1),
          datesBorderColor: const Color.fromARGB(255, 54, 234, 60),
          // datesTextColor: Colors.white,
        ),
      ),
      leadingTrailingDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderRadius: 1000,
        ),
      ),
    );
  }
}
