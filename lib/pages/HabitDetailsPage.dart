// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/BestStreakWidget.dart';
import 'package:habit_tracker/CurrentStreakWidget.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/Metrics.dart';
import 'package:activity_ring/activity_ring.dart';
import 'dart:ui';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:habit_tracker/UpdateStreakMetric.dart';
import 'package:habit_tracker/pages/Rings.dart';
import 'package:habit_tracker/Calendar.dart';
import 'package:intl/intl.dart';

class HabitDetailsPage extends StatelessWidget {
  // suprHabitDetailsPage({super.key});
  // const HabitDetailsPage(this.habit, {super.key});
  late Habit habit;

  HabitDetailsPage(this.habit, {super.key}) {
    print("Inside HabitDetailsPage");

    
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
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[900]),
                  child: Rings(habit)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[900]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      calendar(habit),
                      // Container(
                      //     child: Text(
                      //         "Current Streak" + habit.streaks.toString())),
                      // Container(
                      //     child:
                      //         Text("Max Streak" + habit.maxStreaks.toString())),
                      // Container(
                      //     child: Text("Streak Start Day" +
                      //         habit.streakStartDate.toString())),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
               Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[900]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: CurrentStreakWidget(habit),
                          )),
              const SizedBox(height: 10,),
               Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[900]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: BestStreakWidget(habit),
                          )),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[900]),
                              child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.create,color: habit.color,size: 30,),
                                const SizedBox(width: 6),
                                const Text("Created on ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 16),),
                                const SizedBox(width: 3),
                                Text(DateFormat.yMMMd('en_US').format(habit.habitStartDate),style: TextStyle(color: habit.color,fontWeight: FontWeight.w900,fontSize: 16),),
                              ],
                            ),
                          )),
            ],
          ),
        ),
      ),
    );
  }
}
