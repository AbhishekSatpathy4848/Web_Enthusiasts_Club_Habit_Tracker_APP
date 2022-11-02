import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/Metrics.dart';
import 'package:activity_ring/activity_ring.dart';
import 'dart:ui';

import 'package:hive/hive.dart';

class ProgressRateChart extends StatelessWidget {
  ProgressRateChart({super.key});

  final amber = Color.fromRGBO(255, 192, 29, 1);

  // final metricType == ""

  Widget container(Habit habit, double totalBarWidth) {
    // print(Metrics.getProgressRate(habit) / 100);
    // print(totalBarWidth);
    // print((Metrics.getProgressRate(habit) / 100) * totalBarWidth);
    double width;
    if (habit.getProgressRate() != 0) {
      width = habit.getProgressRate() / 100 * totalBarWidth;
      // width = totalBarWidth;
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

  List<Widget> barCharts(List<Habit> habitlist, BuildContext context) {
    List<Widget> bars = [];
    double totalBarWidth = 180;
    // bars.add(const SizedBox(height: 20));
    for (int i = 0; i < habitlist.length; i++) {
      if (i != 0) {
        bars.add(const SizedBox(height: 20));
      }
      bars.add(Row(mainAxisSize: MainAxisSize.min, children: [
        container(habitlist[i], totalBarWidth),
        const SizedBox(
          width: 10,
        ),
        Text(
          "${habitlist[i].getProgressRate()} %",
          style: TextStyle(color: amber, fontWeight: FontWeight.bold),
        )
      ]));

      // bars.add(Row(mainAxisSize: MainAxisSize.min,children: [container(habitlist[i], totalBarWidth)]));
      // bars.add(container(habitlist[i], totalBarWidth));
    }

    // bars.add(const SizedBox(height: 20));
    return bars.toList();
  }

  displayChartDialog(List<Habit> habitList, BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          // print("dialog" + MediaQuery.of(context).size.width.toString());
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                backgroundColor: Colors.grey[900],
                content: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (barCharts(habitList, context).isNotEmpty)
                          ? barCharts(habitList, context)
                          : const [
                              Center(
                                  child: Text("No Habits Created",
                                      style: TextStyle(color: Colors.white)))
                            ]),
                ),
              ));
        }));
  }

  Ring ringChart(List<Habit> habitlist, BuildContext context, int i,
      double radius, double width) {
    if (i == habitlist.length) {
      return Ring(
          percent: 0,
          width: 0,
          radius: 0,
          color: RingColorScheme(ringColor: Colors.white));
    }

    return Ring(
      percent: habitlist[i].getProgressRate().toDouble(),
      color: RingColorScheme(ringColor: habitlist[i].color),
      radius: radius,
      width: width,
      child: ringChart(habitlist, context, i + 1, radius - width, width),
    );
  }

  Widget gridViewItem(Habit habit) {
    // List<Widget> legend = [];
    // for (int i = 0; i < habitlist.length; i++) {
    return Row(
      children: [
        Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: habit.color),
            width: 20,
            height: 20),
        const SizedBox(width: 10),
        Text(
          "${habit.getProgressRate().toDouble()}%",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
    // );
    // }
    // return legend;
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    List<Habit> habitList = Hive.box<Habit>('habits').values.toList();
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progress Rate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: amber)),
                IconButton(
                    onPressed: () {
                      displayChartDialog(habitList, context);
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ))
              ],
            ),
            Center(
                child: Container(
              height: 260,
              // const SizedBox(width: 100),
              child: habitList.isNotEmpty
                  ? ringChart(habitList, context, i, 100, 12)
                  : const Center(
                      child: Text("No Habits Created",
                          style: TextStyle(color: Colors.white))),
            )),
            SizedBox(
              height: 100,
              // color: Colors.amber,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,

                      // childAspectRatio: 1.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 20,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: habitList.length,
                    itemBuilder: ((context, index) {
                      return gridViewItem(habitList[index]);
                    })),
              ),
            )
          ],
        ));
  }
}
