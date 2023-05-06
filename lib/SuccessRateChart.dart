import 'package:flutter/material.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:activity_ring/activity_ring.dart';
import 'dart:ui';

import 'package:hive_flutter/adapters.dart';

class SuccessRateChart extends StatefulWidget {
  const SuccessRateChart({super.key});

  @override
  State<SuccessRateChart> createState() => _SuccessRateChartState();
}

class _SuccessRateChartState extends State<SuccessRateChart>
    with TickerProviderStateMixin {
  final amber = const Color.fromRGBO(255, 192, 29, 1);

  Widget container(Habit habit, double totalBarWidth) {
    double width;
    if (habit.successRate != 0) {
      width = habit.successRate / 100 * totalBarWidth;
    } else {
      width = 5;
    }
    Tween<double> tween = Tween(begin: 0, end: width);
    AnimationController animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    Animation barAnimation = tween.animate(
        CurvedAnimation(parent: animationController, curve: Curves.decelerate));
    animationController.forward();
    return AnimatedBuilder(
      animation: barAnimation,
      builder: (context, child) {
        return Container(
          width: barAnimation.value,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), color: habit.color),
        );
      },
    );
  }

  List<Widget> barCharts(List<Habit> habitlist, BuildContext context) {
    List<Widget> bars = [];
    double totalBarWidth = 180;
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
          "${habitlist[i].successRate} %",
          style: TextStyle(color: amber, fontWeight: FontWeight.bold),
        )
      ]));
    }
    return bars;
  }

  displayChartDialog(List<Habit> habitList, BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                backgroundColor: Colors.grey[900],
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.62,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (barCharts(habitList, context).isNotEmpty)
                          ? barCharts(habitList, context)
                          : const [
                              Center(
                                  child: Text("No Habits Created",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)))
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
      percent: habitlist[i].successRate.toDouble(),
      color: RingColorScheme(ringColor: habitlist[i].color),
      radius: radius,
      width: width,
      child: ringChart(habitlist, context, i + 1, radius - width, width),
    );
  }

  Widget gridViewItem(Habit habit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: habit.color),
            width: 20,
            height: 20),
        const SizedBox(width: 10),
        Text(
          "${habit.successRate.toDouble()}%",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return ValueListenableBuilder(
        valueListenable: Hive.box<Habit>('habits').listenable(),
        builder: (context, box, child) {
          List<Habit> habitList = box.values.toList();
          return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Success Rate",
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
                  SizedBox(
                    height: 260,
                    child: Center(
                        child: habitList.isNotEmpty
                            ? ringChart(habitList, context, i, 100, 12)
                            : const Center(
                                child: Text("No Habits Created",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)))),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Wrap(spacing: 20, runSpacing: 20, children: [
                      for (int i = 0; i < habitList.length; i++)
                        gridViewItem(habitList[i])
                    ]),
                  )
                ],
              ));
        });
  }
}
