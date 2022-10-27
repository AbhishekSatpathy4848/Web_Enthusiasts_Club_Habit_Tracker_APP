// import 'dart:js';

import 'dart:ui';
import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habit_tracker/Metrics.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:habit_tracker/localNotificationService.dart';
// import 'package:habit_tracker/NotificationAPI.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:date_format/date_format.dart';
import 'package:habit_tracker/getDayDifference.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:checkmark/checkmark.dart';

class HabitList extends StatefulWidget {
  HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList>
    with SingleTickerProviderStateMixin {
  // List<Habit> listHabits = [Habit("habit1"), Habit("habit2")];

  // final VoidCallback addHabit;
  late Color color;
  late AnimationController animationController;
  // bool isTicked = false;

  @override
  void initState() {
    super.initState();
    setColorChoice();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  setColorChoice() {
    color = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  }

  addHabit(String name, Color color, int goalDays) {
    final habit = Habit(
        name,
        color,
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        0,
        0,
        goalDays, []);
    // habit.addToCompletedDays(dateTime)
    final box = Boxes.getHabits();
    box.add(habit);
    setColorChoice();
  }

  deleteHabit(Habit habit) {
    habit.delete();
  }

  void editHabitStreaks(Habit habit, int streaks) {
    habit.streaks = streaks;
    print(habit.streaks);
    habit.save();
  }

  void editHabitStreakBeginDate(Habit habit, DateTime currentDate) {
    habit.streakStartDate = currentDate;
    // print(habit.streaks);
    habit.save();
  }

  void updateMaxStreak(Habit habit, int maxStreaks) {
    habit.maxStreaks = maxStreaks;
    // print(habit.streaks);
    habit.save();
  }

  bool ishabitAlreadyRegistered(Habit habit, DateTime currentDate) {
    // return daysBetween(habit.streakStartDate!, currentDate) > habit.streaks;
    return habit.completedDays.contains(currentDate);
  }

  void addCompletedDate(Habit habit, DateTime currentDate) {
    habit.completedDays.add(currentDate);
    habit.save();
  }

  void showCompletedAnimationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                backgroundColor: Colors.grey[900],
                child: Lottie.network(
                    "https://assets5.lottiefiles.com/packages/lf20_q7hiluze.json"),
              ));
        });
  }

  void markHabitProgress(
      List<Habit> habitlist, int index, DateTime currentDate) {
    if (daysBetween(habitlist[index].streakStartDate!, currentDate) ==
        habitlist[index].streaks) {
      editHabitStreaks(habitlist[index], habitlist[index].streaks + 1);
      addCompletedDate(habitlist[index], currentDate);
      if (habitlist[index].maxStreaks < habitlist[index].streaks) {
        updateMaxStreak(habitlist[index], habitlist[index].streaks);
      }
    } else if (daysBetween(habitlist[index].streakStartDate!, currentDate) >
        habitlist[index].streaks) {
      editHabitStreakBeginDate(habitlist[index], currentDate);
      // showCompletedAnimationDialog();
      editHabitStreaks(habitlist[index], 1);
    }
  }

  Widget chooseIcon(habitlist, index, currentDate) {
    if (ishabitAlreadyRegistered(habitlist[index], currentDate)) {
      return const Icon(Icons.check, color: Color.fromARGB(255, 62, 236, 67));
    } else {
      return AnimatedIcon(
          icon: AnimatedIcons.arrow_menu, progress: animationController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
            foregroundColor: Colors.blue,
            onPressed: () {
              // NotificationApi.showNotification(
              //       title: "First Flutter Notification",
              //       body: "We are building the IRIS Flutter Project");
              showHabitCreationDialog(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
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
                      final currentDate = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day);
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                color: const Color.fromRGBO(40, 40, 40, 1),
                                child: ListTile(
                                    title: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              habitlist[index].name.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            // Text(formatDate(
                                            //     habitlist[index]
                                            //         .streakStartDate!,
                                            //     [dd, '-', mm, '-', yyyy])),
                                          ],
                                        ),
                                        // Text("hey")
                                      ],
                                    ),
                                    leading: Container(
                                      width: 10,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: habitlist[index].color),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // IconButton(
                                        //     onPressed: () {
                                        //       if (!ishabitAlreadyRegistered(
                                        //           habitlist[index],
                                        //           currentDate)) {
                                        //         // animationController.forward();
                                        //         markHabitProgress(habitlist,
                                        //             index, currentDate);
                                        //       } else {
                                        //         print(
                                        //             "Already registerered for the day");
                                        //       }
                                        //     },
                                        //     // icon: chooseIcon(
                                        //     //     habitlist, index, currentDate)),
                                        //     icon: ),
                                        GestureDetector(
                                              onTap: () {
                                                // setState(() {
                                                  // isTicked = !isTicked;
                                                  // print(isTicked);
                                                  if (!ishabitAlreadyRegistered(habitlist[index],currentDate)) {
                                                    markHabitProgress(habitlist,index, currentDate);
                                                  } else {
                                                  print("Already registerered for the day");
                                                }
                                              // });
                                              },
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: CheckMark(
                                                  active: ishabitAlreadyRegistered(habitlist[index],currentDate),
                                                  curve: Curves.decelerate,
                                                  strokeWidth: 3,
                                                  activeColor:
                                                      const Color.fromARGB(
                                                          255, 62, 236, 67),
                                                  // strokeJoin: StrokeJoin.miter,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(width: 10),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 225, 90, 78)),
                                          onPressed: () =>
                                              deleteHabit(habitlist[index]),
                                        ),
                                      ],
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
                                                        BorderRadius.circular(
                                                            15.0)),
                                                backgroundColor:
                                                    Colors.grey[900],
                                                child: dialogContent(
                                                    habitlist[index], context),
                                              ),
                                            );
                                          });
                                    })),
                            // const SizedBox(height: 0),
                            // Container(color: const Color.fromRGBO(40, 40, 40, 1),child: TextButton(onPressed: (){

                            // }, child: Text("Mark as Completed"))),
                            // const SizedBox(height: 10)
                          ]);
                      // }));
                    }),
                  );
                }))));
  }

  showHabitCreationDialog(BuildContext context) {
    final habitNameController = TextEditingController();
    final goalDaysController = TextEditingController();

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
            content: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: habitNameController,
                    decoration: const InputDecoration(
                      // suffixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      labelText: 'Habit Name',
                      // hintText: 'Enter Your Password',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: goalDaysController,
                    decoration: const InputDecoration(
                      // suffixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      labelText: 'Goal',
                      // hintText: 'Enter Your Password',
                    ),
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
                                    content: ColorPicker(
                                        pickerColor: color,
                                        onColorChanged: (color) {
                                          setState(() {
                                            this.color = color;
                                          });
                                        }),
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
            }),
            actions: [
              TextButton(
                  onPressed: () {
                    // callbackFunction(Habit(controller.text.trim()));
                    addHabit(habitNameController.text.trim(), color,
                        int.parse(goalDaysController.text.trim()));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Create Habit")),
            ],
          );
          // }
          // );
        });
  }

  Widget dialogContent(Habit habit, BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 260,
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text(habit.name.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: Metrics.getProgressRate(habit).toDouble(),
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromARGB(255, 237, 183, 5)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text(
                                  "${Metrics.getProgressRate(habit).toString()}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Progress Rate",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ]),
                  const SizedBox(width: 50),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: Metrics.getSuccessRate(habit).toDouble(),
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromARGB(255, 15, 232, 127)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text(
                                  "${Metrics.getSuccessRate(habit).toString()}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Success Rate",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ]),
                ]),
              ],
            )));
  }

  // showColorPickerDialog(BuildContext context) {}
}
