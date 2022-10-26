// import 'dart:js';

import 'dart:ui';
import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HabitList extends StatefulWidget {
  HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  // List<Habit> listHabits = [Habit("habit1"), Habit("habit2")];

  // final VoidCallback addHabit;
  Color color = Colors.blue;

  addHabit(String name, Color color) {
    final habit = Habit(name, color);
    final box = Boxes.getHabits();
    box.add(habit);
  }

  deleteHabit(Habit habit) {
    habit.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showHabitCreationDialog(context);
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
                              leading: Container(
                                width: 10,
                                height: 40,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: habitlist[index].color),
                              ),
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
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          backgroundColor: Colors.grey[900],
                                          child: dialogContent(index),
                                        ),
                                      );
                                    });
                              }));
                      // }));
                    }),
                  );
                }))));
  }

  showHabitCreationDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          // return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Add a Habit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              elevation: 100,
              content: StatefulBuilder(builder: (context,setState) { 
                return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            // setState() {
                            // showColorPickerDialog(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Pick your Habit color"),
                                    content: Column(
                                      children: [
                                        ColorPicker(
                                            pickerColor: color,
                                            onColorChanged: (color) {
                                              setState(() {
                                                this.color = color;
                                              });
                                            })
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Done"))
                                    ],
                                  );
                                });
                            },
                          // },
                          child: const Text("Choose Color")),
                      Container(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: color),
                        width: 20,
                        height: 20,
                      )
                    ],
                  )
                ],
              );
            }
            ),
              actions: [
                TextButton(
                    onPressed: () {
                      // callbackFunction(Habit(controller.text.trim()));
                      addHabit(controller.text.trim(), color);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Create Habit")),
              ],
            );
          // }
          // );
        });
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

  // showColorPickerDialog(BuildContext context) {}
}
