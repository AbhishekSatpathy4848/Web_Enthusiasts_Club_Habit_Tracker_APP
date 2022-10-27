import 'package:flutter/material.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/Metrics.dart';

class SuccessRateChart extends StatelessWidget {
  const SuccessRateChart({super.key});
  final amber = const Color.fromRGBO(255, 192, 29, 1);

  Widget container(Habit habit, double totalBarWidth) {
    // print(Metrics.getSuccessRate(habit) / 100);
    // print(totalBarWidth);
    // print((Metrics.getSuccessRate(habit) / 100) * totalBarWidth);
    double width;
    if (Metrics.getSuccessRate(habit) != 0) {
      width = Metrics.getSuccessRate(habit) / 100 * totalBarWidth;
    } else {
      width = 5;
    }
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: habit.color),
    );
  }

  List<Widget> buildCharts(List<Habit> habitlist, BuildContext context) {
    List<Widget> bars = [];
    double totalBarWidth = MediaQuery.of(context).size.width - 100;
    for (int i = 0; i < habitlist.length; i++) {
      bars.add(const SizedBox(height: 20));
      bars.add(Row(mainAxisSize: MainAxisSize.min, children: [
        container(habitlist[i], totalBarWidth),
        const SizedBox(
          width: 10,
        ),
        Text(
          "${Metrics.getSuccessRate(habitlist[i])} %",
          style: TextStyle(color: amber, fontWeight: FontWeight.bold),
        )
      ]));
      // bars.add(Row(mainAxisSize: MainAxisSize.min,children: [container(habitlist[i], totalBarWidth)]));
      // bars.add(container(habitlist[i], totalBarWidth));
    }

    return bars;
  }


  @override
  Widget build(BuildContext context) {
    List<Habit> habitList = Boxes.getHabits().values.toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Success Rate",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22, color: amber)),
            // SizedBox(width: 40),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildCharts(habitList, context),
            )),
            const SizedBox(height: 40),
            Text("Progress Rate",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22, color: amber)),
            // SizedBox(width: 40),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildCharts(habitList, context),
            )),
          ],
        ),






      ),
    );
  }
}
