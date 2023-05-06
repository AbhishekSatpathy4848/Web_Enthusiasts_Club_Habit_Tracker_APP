// import 'dart:js';

// import 'dart:html';
import 'dart:ui';
import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/UpdateStreakMetric.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitDetailsPage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:date_format/date_format.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:checkmark/checkmark.dart';

class HabitList extends StatefulWidget {
  const HabitList({super.key});

  @override
  State<HabitList> createState() {
    return _HabitListState();
  }
}

class _HabitListState extends State<HabitList> {
  // List<Habit> listHabits = [Habit("habit1"), Habit("habit2")];

  // final VoidCallback addHabit;
  late Color color;
  late AnimationController animationController;
  late DateTime currentTime = DateTime(0, 0, 0);
  // bool isTicked = false;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('state = $state');
  //   // if (state == AppLifecycleState.resumed) {
  //   //   build(context);
  //   // }
  // }

  // handleAppLifecycleState() {
  //   SystemChannels.lifecycle.setMessageHandler((msg) async {
  //     if (msg == "AppLifecycleState.resumed") {
  //       setState(() {
  //         currentTime = DateTime.now();
  //         checkHabitCompletedAndCallDialog();
  //       });
  //     }
  //     return null;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // openHiveBox();
    // handleAppLifecycleState();
    setColorChoice();
    // animationController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // print(checkHabitCompleted());
  }

  setColorChoice() {
    color = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  }

  addHabit(String name, Color color, int goalDays) {
    for (Habit habit in Hive.box<Habit>('habits').values.toList()) {
      if (habit.name == name) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Habit name already exist!! Choose another name.")));
        return;
      } else if (habit.color == color) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Habit colour is already choosen!! Choose another colour.")));
        return;
      }
    }
    final habit = Habit(
        name: name,
        color: color,
        streakStartDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        habitStartDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        goalDays: goalDays,
        completedDays: [],
        bestStreakStartDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));

    final box = Hive.box<Habit>('habits');
    box.put(habit.name, habit);
    habit.save();
  }

  deleteHabit(Habit habit) {
    habit.delete();
  }

  addToCompletedHabits(Habit habit) {
    final box = Hive.box<Habit>('completedHabits');
    box.put(habit.name, habit);
    habit.save();
  }

  // void editHabitStreaks(Habit habit, int streaks) {
  //   habit.streaks = streaks;
  //   print(habit.streaks);
  //   habit.save();
  // }

  // void editHabitStreakBeginDate(Habit habit, DateTime currentDate) {
  //   habit.streakStartDate = currentDate;
  //   // print(habit.streaks);
  //   habit.save();
  // }

  // void updateMaxStreak(Habit habit, int maxStreaks) {
  //   habit.maxStreaks = maxStreaks;
  //   // print(habit.streaks);
  //   habit.save();
  // }

  // bool ishabitAlreadyRegisteredForTheDay(Habit habit, DateTime currentDate) {
  //   // return daysBetween(habit.streakStartDate!, currentDate) > habit.streaks;
  //   return habit.completedDays.contains(currentDate);
  // }

  // void addCompletedDate(Habit habit, DateTime currentDate) {
  //   habit.completedDays.add(currentDate);
  //   habit.save();
  // }

  void habitCompletedDialog(Habit habit) {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                backgroundColor: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 25.0, 40.0, 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset("lottie/congratulations_lottie.json",
                          height: 200, width: 200),
                      const SizedBox(height: 20),
                      const Text(
                        "Congratulations!!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "You have successfully completed ${habit.name}.",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void markHabitProgress(
      List<Habit> habitlist, int index, DateTime currentDate) async {
    habitlist[index].registerDay(currentDate);
    habitlist[index].updateProgressRate();
    habitlist[index].updateSuccessRate();
    updateStreakMetrics(habitlist[index], currentDate);
    await habitlist[index].save();
    checkHabitCompletedAndCallDialog();
  }

  // Widget chooseIcon(habitlist, index, currentDate) {
  //   if (ishabitAlreadyRegisteredForTheDay(habitlist[index], currentDate)) {
  //     return const Icon(Icons.check, color: Color.fromARGB(255, 62, 236, 67));
  //   } else {
  //     return AnimatedIcon(
  //         icon: AnimatedIcons.arrow_menu, progress: animationController);
  //   }
  // }

  void checkHabitCompletedAndCallDialog() {
    for (Habit habit in Hive.box<Habit>('habits').values.toList()) {
      // print(daysBetween(habit.habitStartDate, currentDay));
      if (habit.progressRate >= 100) {
        habitCompletedDialog(habit);
        deleteHabit(habit);
        addToCompletedHabits(habit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Running Build");
    // if (checkHabitCompleted()) {
    //   habitCompletedDialog();
    // }
    return Scaffold(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
            foregroundColor: Colors.blue,
            onPressed: () {
              // NotificationApi.showNotification(
              //       title: "First Flutter Notification",
              //       body: "We are building the IRIS Flutter Project");
              if (Hive.box<Habit>('habits').values.toList().length < 8) {
                showHabitCreationDialog(context);
                setColorChoice();
              } else {
                Fluttertoast.showToast(
                  msg: "Only 8 habits can be created per user!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Create Habit",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
            child: ValueListenableBuilder(
                valueListenable: Hive.box<Habit>('habits').listenable(),
                builder: ((context, box, widget) {
                  List<Habit> habitlist = box.values.toList();
                  return habitlist.isEmpty
                      ? const Center(
                          child: Text(
                            "No Habits!!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        )
                      : ListView.builder(
                          itemCount: Hive.box<Habit>('habits').keys.length,
                          itemBuilder: ((context, index) {
                            final currentDate = DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      color:
                                          const Color.fromRGBO(40, 40, 40, 1),
                                      child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  habitlist[index]
                                                      .name
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),

                                              // //used to rebuild widgets when Day changes, not actually displayed
                                              // SizedBox(
                                              //   width: 0,
                                              //   height: 0,
                                              //   child: Text(formatDate(
                                              //       currentTime,
                                              //       [dd, '-', mm, '-', yyyy])),
                                              // ),
                                            ],
                                          ),
                                          minLeadingWidth: 10,
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
                                                  print("Tap detected");
                                                  if (!habitlist[index]
                                                      .ishabitAlreadyRegisteredForTheDay(
                                                          currentDate)) {
                                                    markHabitProgress(habitlist,
                                                        index, currentDate);
                                                  } else {
                                                    print(habitlist[index]
                                                        .completedDays);
                                                    print(
                                                        "Already registerered for the day");
                                                  }
                                                  // });
                                                },
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: CheckMark(
                                                    active: habitlist[index]
                                                        .ishabitAlreadyRegisteredForTheDay(
                                                            currentDate),
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
                                                onPressed: () => deleteHabit(
                                                    habitlist[index]),
                                              ),
                                            ],
                                          ),
                                          onTap: (() {
                                            // habitlist[index]
                                            //     .updateProgressRate();
                                            // habitlist[index]
                                            //     .updateSuccessRate();
                                            // updateStreakMetrics(
                                            //     habitlist[index],
                                            //     DateTime(
                                            //         DateTime.now().year,
                                            //         DateTime.now().month,
                                            //         DateTime.now().day));
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: ((context) =>
                                                        HabitDetailsPage(
                                                            habit: habitlist[
                                                                index]))));
                                            // Navigator.push(context, )
                                          }),
                                          onLongPress: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 5, sigmaY: 5),
                                                    child: Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      backgroundColor:
                                                          Colors.grey[900],
                                                      child: dialogContent(
                                                          habitlist[index],
                                                          context),
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
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: Colors.grey[900],
              title: const Text(
                "Add a Habit",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.green),
              ),
              elevation: 100,
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: StatefulBuilder(builder: (context, setState) {
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Target Days',
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          backgroundColor: const Color.fromRGBO(
                                              40, 40, 40, 1),
                                          // insetPadding: const EdgeInsets.all(30.0),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          // buttonPadding: const EdgeInsets.all(40.0),
                                          title: const Text(
                                              "Pick your Habit color"),
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
                                        ),
                                      );
                                    });
                              },
                              // },
                              child: const Text("Choose Color")),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: color),
                            width: 25,
                            height: 25,
                          )
                        ],
                      )
                    ],
                  );
                }),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      // callbackFunction(Habit(controller.text.trim()));
                      addHabit(habitNameController.text.trim(), color,
                          int.parse(goalDaysController.text.trim()));
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Create Habit",
                      style: TextStyle(color: Colors.amberAccent[200]),
                    )),
              ],
            ),
          );
          // }
          // );
        });
  }

  Widget dialogContent(Habit habit, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(habit.name.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: habit.progressRate.toDouble(),
                          color: RingColorScheme(
                              ringColor: const Color.fromRGBO(249, 17, 79, 1)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text("${habit.progressRate.toString()}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Progress Rate",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: habit.successRate.toDouble(),
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromARGB(255, 15, 232, 127)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text("${habit.successRate.toString()}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Success Rate",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )
                      ])
                ]),
          ],
        ));
  }
}
