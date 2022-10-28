import 'package:flutter/material.dart';
import 'package:habit_tracker/SuccessRateChart.dart';
import 'package:hive/hive.dart';
// import 'package:habit_tracker/NotificationAPI.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    // final currentDate = DateTime.now();
    // List<Habit> habits = Boxes.getHabits().values.toList();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26,26,26,1),
      body: Column(
        children: [
          SuccessRateChart(),
          // SuccessRateLegend();
        ],
      ),
    );
  }
}
