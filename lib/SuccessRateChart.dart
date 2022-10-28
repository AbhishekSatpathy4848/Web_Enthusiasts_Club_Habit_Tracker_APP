import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/Metrics.dart';
import 'package:activity_ring/activity_ring.dart';

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

  Ring rings(List<Habit> habitlist, BuildContext context, int i, double radius,
      double width) {
    if (i == habitlist.length)
      return Ring(
          percent: 100,
          width: 0,
          color: RingColorScheme(ringColor: Colors.white));

    return Ring(
      percent: Metrics.getSuccessRate(habitlist[i]).toDouble(),
      color: RingColorScheme(ringColor: habitlist[i].color),
      radius: radius,
      width: width,
      child: rings(habitlist, context, i + 1, radius - width, width),
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
          "${Metrics.getSuccessRate(habit).toDouble()}%",
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
    List<Habit> habitList = Boxes.getHabits().values.toList();
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
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
                      // displayChartDialog();
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
              child: rings(habitList, context, i, 100, 12),
            )),
            Container(
              height: 100,
              // color: Colors.amber,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            )
            // ),

            //     Container(
            //         child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: buildCharts(habitList, context),
            //     )),
            //     const SizedBox(height: 40),
            //     Text("Progress Rate",
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold, fontSize: 22, color: amber)),
            //     // SizedBox(width: 40),
            //     Container(
            //         child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: buildCharts(habitList, context),
            //     )),
          ],
        ));
  }
}
