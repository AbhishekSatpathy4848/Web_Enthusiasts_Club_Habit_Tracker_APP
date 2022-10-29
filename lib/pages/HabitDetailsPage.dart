import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/Metrics.dart';
import 'package:activity_ring/activity_ring.dart';
import 'dart:ui';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:habit_tracker/UpdateStreakMetric.dart';

class HabitDetailsPage extends StatelessWidget {
  // suprHabitDetailsPage({super.key});
  // const HabitDetailsPage(this.habit, {super.key});
  late Habit habit;

  HabitDetailsPage(this.habit, {super.key}) {
    print("Inside HabitDetailsPage");

    updateStreakMetrics(habit, DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        title: Text(habit.name),
        // backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Theme(
            // data: ThemeData(primarySwatch: Colors.white),
            CleanCalendar(
              datesForStreaks: habit.completedDays,
              // generalDatesProperties: DatesProperties(
              //   datesDecoration: DatesDecoration(
              //     datesBorderRadius: 1000,
              //     datesBackgroundColor: Colors.lightGreen.shade100,
              //     datesBorderColor: Colors.blue.shade100,
              //     datesTextColor: Colors.black,
              //   ),
              // )
            ),
            // )
            Container(child: Text("Current Streak" + habit.streaks.toString())),
            Container(child: Text("Max Streak" + habit.maxStreaks.toString())),
            Container(
                child:
                    Text("Streak Start Day" + habit.streakStartDate.toString()))
          ],
        ),
      ),
    );
  }
}
