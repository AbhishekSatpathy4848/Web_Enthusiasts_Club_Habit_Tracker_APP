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
import 'package:habit_tracker/pages/Rings.dart';

class HabitDetailsPage extends StatelessWidget {
  // suprHabitDetailsPage({super.key});
  // const HabitDetailsPage(this.habit, {super.key});
  late Habit habit;

  HabitDetailsPage(this.habit, {super.key}) {
    print("Inside HabitDetailsPage");

    updateStreakMetrics(
        habit,
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        title: Text(
          habit.name,
          style: TextStyle(color: Colors.amberAccent[200]),
        ),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[900]),
                  child: Rings(habit)),
                const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[900]),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CleanCalendar(
                        datesForStreaks: habit.completedDays,
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
                            datesBackgroundColor:
                                const Color.fromRGBO(26, 26, 26, 1),
                            datesBorderColor:
                                const Color.fromARGB(255, 54, 234, 60),
                            // datesTextColor: Colors.white,
                          ),
                        ),
                        leadingTrailingDatesProperties: DatesProperties(
                          datesDecoration: DatesDecoration(
                            datesBorderRadius: 1000,
                          ),
                        ),
                      ),
                      Container(
                          child: Text(
                              "Current Streak" + habit.streaks.toString())),
                      Container(
                          child:
                              Text("Max Streak" + habit.maxStreaks.toString())),
                      Container(
                          child: Text("Streak Start Day" +
                              habit.streakStartDate.toString()))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
