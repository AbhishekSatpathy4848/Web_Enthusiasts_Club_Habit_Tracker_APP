import 'package:flutter/material.dart';
import 'package:habit_tracker/Habit.dart';

class HabitList extends StatefulWidget {
  const HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Habit> habits = [Habit("habit1"), Habit("habit2")];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
      child: ListView.builder(
        itemCount: habits.length,
        itemBuilder: ((context, index) {
          return SizedBox(
            height: 80,
            child: Card(
              // clipBehavior: Clip.antiAlias,
              shape: (RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                // side: BorderSide(color: Colors.amberAccent[200]!)
              )),
              color: Colors.grey[800],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   color: Colors.amber,
                  //   child: Text(""),
                  //   width: 10,
                  // ),
                  Text(habits[index].name!),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
