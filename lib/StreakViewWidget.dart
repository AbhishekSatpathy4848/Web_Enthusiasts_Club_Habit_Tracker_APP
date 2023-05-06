import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:habit_tracker/UpdateStreakMetric.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StreakViewWidget extends StatelessWidget {
  const StreakViewWidget({super.key});

  List<TableRow> createTableRows(List<Habit> habitList) {
    List<TableRow> tableRows = [];
    tableRows.add(const TableRow(
      children: [
        Text(
          "Habit Name",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(255, 192, 29, 1)),
        ),
        Text(
          "Current Streaks",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(255, 192, 29, 1)),
        ),
        Text(
          "Max Streaks",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(255, 192, 29, 1)),
        )
      ],
    ));
    tableRows.add(const TableRow(children: [Text(" "), Text(" "), Text(" ")]));
    for (Habit habit in habitList) {
      tableRows.add(TableRow(children: [
        Row(
          children: [
            const SizedBox(width: 4),
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: habit.color)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(habit.name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        Text(habit.streaks.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        Text(habit.maxStreaks.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ]));
      tableRows.add(const TableRow(
          // decoration: ,
          children: [
            Text("", style: TextStyle(fontSize: 8)),
            Text("", style: TextStyle(fontSize: 8)),
            Text("", style: TextStyle(fontSize: 8)),
          ]));
    }

    return tableRows.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Habit>('habits').listenable(),
        builder: (context, box, child) {
          List<Habit> habitList = box.values.toList();
          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            child: Column(children: [
              Table(children: createTableRows(habitList)),
              createTableRows(habitList).length == 2
                  ? Center(
                      child: Column(
                      children: const [
                        SizedBox(height: 10),
                        Text("No Habits Created",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ],
                    ))
                  : const SizedBox()
            ]),
          );
        });
  }
}
