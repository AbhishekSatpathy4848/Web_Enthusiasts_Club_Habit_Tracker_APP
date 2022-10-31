import 'package:flutter/material.dart';
import 'package:habit_tracker/SuccessRateChart.dart';
import 'package:habit_tracker/ProgressRateChart.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/StreakViewWidget.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,20,20,20.0),
          child: Column(
            children: [
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: Colors.grey[900]),child: ProgressRateChart()),
              const SizedBox(height: 15),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: Colors.grey[900]),child: SuccessRateChart()),
              const SizedBox(height: 15),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: Colors.grey[900]),child: StreakViewWidget())
              // SuccessRateLegend();
            ],
          ),  
        ),
      ),
    );
  }
}
