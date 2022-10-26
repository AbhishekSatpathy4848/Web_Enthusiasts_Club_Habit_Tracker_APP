// import 'dart:js';

import 'dart:ui';
import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitList extends StatefulWidget {
  HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  // List<Habit> listHabits = [Habit("habit1"), Habit("habit2")];

  addHabit(String name) {
    final habit = Habit(name);
    final box = Boxes.getHabits();
    box.add(habit);
  }

  deleteHabit(Habit habit) {
    habit.delete();
  }

  AlertDialog BuildAlert(BuildContext context) {
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text(
        "Add a Habit",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      elevation: 100,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              // callbackFunction(Habit(controller.text.trim()));
              addHabit(controller.text.trim());
              Navigator.of(context).pop();
            },
            child: const Text("Create Habit")),
      ],
    );
  }

  Widget dialogContent(int index) {
    return Container(
        width: 300,
        height: 260,
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // Text(listHabits[index].name.toString(),
                //     style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: 50,
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromARGB(255, 237, 183, 5)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text("50%",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Progress Rate",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                  const SizedBox(width: 60),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: 100,
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromARGB(255, 15, 232, 127)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text("100%",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Success Rate",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                ]),
              ],
            )));
  }

  // final VoidCallback addHabit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => BuildAlert(context));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: const Icon(Icons.add)),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
            child: ValueListenableBuilder(
            valueListenable: Boxes.getHabits().listenable(),
            builder: ((context, box, widget) {
              List<Habit> habitlist = box.values.toList();
              return ListView.builder(
                itemCount: Boxes.getHabits().keys.length,
                itemBuilder: ((context, index) {
                        return Card(
                            child: ListTile(
                                title: Text(habitlist[index].name.toString()),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => deleteHabit(habitlist[index]),
                                ),
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: Container(
                                            // width: 350,
                                            // height: 150,
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              backgroundColor: Colors.grey[900],
                                              child: dialogContent(index),
                                            ),
                                          ),
                                        );
                                      });
                                }));
                      // }));
                }),
              );
            }
          )
       )
      )
    );
  }
}
