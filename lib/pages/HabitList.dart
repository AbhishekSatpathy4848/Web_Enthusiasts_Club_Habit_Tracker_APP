// import 'dart:js';

// import 'dart:html';
import 'dart:async';
import 'dart:ui';
import 'package:activity_ring/activity_ring.dart';
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/UpdateStreakMetric.dart';
import 'package:habit_tracker/localNotificationService.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitDetailsPage.dart';
import 'package:habit_tracker/provider_shared_state.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:checkmark/checkmark.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> triggerBellIconRebuild = ValueNotifier(false);
  bool switchWidget = false;
  Habit? upcomingHabit;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setColorChoice();
    upcomingHabit = getUpcomingHabit(Hive.box<Habit>('habits').values.toList());
    LocalNotificationService.init();
  }

  setColorChoice() {
    color = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  }

  addHabit(BuildContext context, String name, Color color, int goalDays,
      DateTime? reminderTime) {
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
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        dailyReminderTime: reminderTime);

    if (reminderTime != null) {
      // final cron = Cron();
      // cron.schedule(
      //     Schedule.parse("${reminderTime.minute} ${reminderTime.hour} * * *"),
      //     () {
      LocalNotificationService.showScheduledNotification(
          id: generateUniqueNotficationId(habit),
          title: "Reminder",
          body: "Time to complete your habit ${habit.name}",
          scheduledTime: reminderTime);
      // });
      // Provider.of<SharedState>(context, listen: false)
      //     .cronHabitReminders[name] = cron;
    }
    final box = Hive.box<Habit>('habits');
    //appending habit created datetime to the key to in order to sort the entries based on latest appended habit
    box.put("${DateTime.now()}${habit.name}", habit);
    habit.save();
    toggleBellIconRebuild();
    upcomingHabit = getUpcomingHabit(Hive.box<Habit>('habits').values.toList());
  }

  deleteHabit(Habit habit) {
    habit.delete();
    toggleBellIconRebuild();
    upcomingHabit = getUpcomingHabit(Hive.box<Habit>('habits').values.toList());
  }

  addToCompletedHabits(Habit habit) {
    final box = Hive.box<Habit>('completedHabits');
    box.put(habit.name, habit);
    habit.save();
  }

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
    toggleBellIconRebuild();
    upcomingHabit = getUpcomingHabit(Hive.box<Habit>('habits').values.toList());
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
        // Provider.of<SharedState>(context, listen: false)
        //     .cronHabitReminders
        //     .remove(habit.name);
        LocalNotificationService.cancelNotifcation(
            generateUniqueNotficationId(habit));
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
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: switchWidget
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color.fromRGBO(40, 40, 40, 1),
                          border: Border.all(color: upcomingHabit!.color)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer, color: Colors.red),
                            const SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                  "${upcomingHabit!.name}\t\t${formatToHabitReminderTime(upcomingHabit!.dailyReminderTime!)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      )),
                )
              : Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton.extended(
                          backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
                          foregroundColor: Colors.blue,
                          onPressed: () {
                            if (Hive.box<Habit>('habits')
                                    .values
                                    .toList()
                                    .length <
                                8) {
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
                    ),
                    ValueListenableBuilder(
                        valueListenable: triggerBellIconRebuild,
                        builder: (context, value, child) {
                          return getUpcomingHabitIconWidget(
                              Hive.box<Habit>('habits').values.toList());
                        })
                  ],
                ),
        ),
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
                          itemCount: habitlist.length,
                          itemBuilder: ((context, index) {
                            final currentDate = DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  color: const Color.fromRGBO(40, 40, 40, 1),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
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
                                            GestureDetector(
                                              onTap: () {
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
                                                    size: 28,
                                                    color: Color.fromARGB(
                                                        255, 225, 90, 78)),
                                                onPressed: () {
                                                  showDeleteHabitDialog(
                                                      deleteHabit,
                                                      context,
                                                      habitlist[index]);
                                                }),
                                          ],
                                        ),
                                        onTap: (() {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: ((context) =>
                                                      HabitDetailsPage(
                                                        habit: habitlist[index],
                                                        onBackPress:
                                                            toggleBellIconRebuild,
                                                      ))));
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
                                        }),
                                  )),
                            );
                            // }));
                          }),
                        );
                }))));
  }

  showHabitCreationDialog(BuildContext context) {
    final habitNameController = TextEditingController();
    final goalDaysController = TextEditingController();
    DateTime? reminderDateTime;

    showDialog(
        context: context,
        builder: (context) {
          // return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: Colors.grey[900],
              titlePadding:
                  const EdgeInsets.only(top: 28, bottom: 10, left: 24),
              title: const Text(
                "Add a Habit",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.green),
              ),
              elevation: 100,
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: StatefulBuilder(builder: (context, setState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: habitNameController,
                          decoration: const InputDecoration(
                            // suffixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            labelText: 'Habit Name',
                            // hintText: 'Enter Your Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the habit name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: goalDaysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            labelText: 'Target Days',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the target days';
                            }
                            final validIntegerNumberRegex =
                                RegExp(r"^[1-9][0-9]*$");
                            if (!validIntegerNumberRegex.hasMatch(value)) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () => showHabitTimePicker(context: context)
                              .then((value) {
                            setState(() {
                              if (value != null) {
                                final now = DateTime.now();
                                reminderDateTime = DateTime(now.year, now.month,
                                    now.day, value.hour, value.minute);
                              }
                            });
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    reminderDateTime == null
                                        ? "Select Daily Reminder Time"
                                        : DateFormat('hh:mm a')
                                            .format(reminderDateTime!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            backgroundColor:
                                                const Color.fromRGBO(
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
                                child: const Text(
                                  "Choose Color",
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: color),
                              width: 25,
                              height: 25,
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        addHabit(
                            context,
                            habitNameController.text.trim(),
                            color,
                            int.parse(goalDaysController.text.trim()),
                            reminderDateTime);
                        Navigator.of(context).pop();
                      }
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

  Timer? timer;
  Widget getUpcomingHabitIconWidget(List<Habit> habits) {
    return getUpcomingHabit(Hive.box<Habit>('habits').values.toList()) != null
        ? Align(
            alignment: Alignment.bottomRight,
            child: RawMaterialButton(
              padding: const EdgeInsets.all(4.0),
              onPressed: () {},
              shape: const CircleBorder(),
              fillColor: const Color.fromRGBO(40, 40, 40, 1),
              child: InkWell(
                  onTap: () {
                    timer = Timer(const Duration(seconds: 2), () {
                      switchWidget = !switchWidget;
                      setState(() {});
                    });
                    switchWidget = !switchWidget;
                    setState(() {});
                  },
                  child: Lottie.asset("lottie/bell_lottie.json",
                      height: 30, width: 30)),
            ))
        : const SizedBox();
  }

  void toggleBellIconRebuild() {
    triggerBellIconRebuild.value = !triggerBellIconRebuild.value;
    upcomingHabit = getUpcomingHabit(Hive.box<Habit>('habits').values.toList());
  }
}

Habit? getUpcomingHabit(List<Habit> habits) {
  Habit? upcomingHabit;
  Duration upcomingHabitDuration = const Duration(days: 365);
  DateTime now = DateTime.now();
  for (var habit in habits) {
    if (habit.dailyReminderTime == null) continue;
    if (habit.ishabitAlreadyRegisteredForTheDay(
        DateTime(now.year, now.month, now.day))) continue;
    final updatedDailyReminderTime = DateTime(now.year, now.month, now.day,
        habit.dailyReminderTime!.hour, habit.dailyReminderTime!.minute);
    if (!updatedDailyReminderTime.isAfter(now)) continue;
    if (updatedDailyReminderTime.difference(now) < upcomingHabitDuration) {
      upcomingHabit = habit;
      upcomingHabitDuration = habit.dailyReminderTime!.difference(now);
    }
    break;
  }
  return upcomingHabit;
}

String formatToHabitReminderTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

int generateUniqueNotficationId(Habit habit) {
  //TODO:format to exact milliseconds
  return int.parse(DateFormat('ddmmyykkmm').format(habit.habitStartDate));
}

void showDeleteHabitDialog(
    Function(Habit) function, BuildContext context, Habit habit) {
  showDialog(
      context: context,
      builder: ((context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    function(habit);
                    Navigator.pop(context);
                  },
                  child: const Text("Continue"),
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: Colors.grey[900],
              title: Text(
                "Delete Habit",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.redAccent.shade100,
                    fontWeight: FontWeight.w600),
              ),
              content: const Text(
                "Are you sure you want to delete this habit permanently? This action cannot be undone.",
                style: TextStyle(
                    height: 1.4,
                    wordSpacing: 1.0,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ));
      }));
}
