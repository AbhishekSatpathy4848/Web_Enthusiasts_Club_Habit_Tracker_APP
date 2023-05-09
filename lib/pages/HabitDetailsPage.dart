import 'package:flutter/material.dart';
import 'package:habit_tracker/BestStreakWidget.dart';
import 'package:habit_tracker/CurrentStreakWidget.dart';
import 'package:habit_tracker/localNotificationService.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/pages/Rings.dart';
import 'package:habit_tracker/Calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HabitDetailsPage extends StatelessWidget {
  Habit habit;
  VoidCallback? onBackPress;

  HabitDetailsPage({required this.habit, this.onBackPress, super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPress?.call();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        appBar: AppBar(
          title: Text(
            habit.name,
            style: TextStyle(color: Colors.amberAccent[200]),
          ),
          backgroundColor: Colors.grey[900],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[900]),
                    child: Rings(habit)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[900]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        calendar(habit),
                        // Container(
                        //     child: Text(
                        //         "Current Streak" + habit.streaks.toString())),
                        // Container(
                        //     child:
                        //         Text("Max Streak" + habit.maxStreaks.toString())),
                        // Container(
                        //     child: Text("Streak Start Day" +
                        //         habit.streakStartDate.toString())),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[900]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: CurrentStreakWidget(habit),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[900]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: BestStreakWidget(habit),
                    )),
                const SizedBox(
                  height: 10,
                ),
                !habit.isCompleted()
                    ? Column(
                        children: [
                          ValueListenableBuilder(
                              valueListenable:
                                  Hive.box<Habit>('habits').listenable(),
                              builder: (context, box, child) {
                                return Stack(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: Colors.grey[900]),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              habit.dailyReminderTime != null
                                                  ? "Daily Reminder Time: ${formatToHabitReminderTime(getHabitWithName(box, habit.name)?.dailyReminderTime! ?? DateTime.now())}"
                                                  : "Set Daily Reminder Time",
                                              style: TextStyle(
                                                  color:
                                                      Colors.amberAccent[200],
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: IconButton(
                                            onPressed: () {
                                              showHabitTimePicker(
                                                      habit: habit,
                                                      context: context)
                                                  .then((value) {
                                                if (value != null) {
                                                  final now = DateTime.now();
                                                  habit.dailyReminderTime =
                                                      DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          value.hour,
                                                          value.minute);
                                                  habit.save();
                                                  int id =
                                                      generateUniqueNotficationId(
                                                          habit);
                                                  LocalNotificationService
                                                      .cancelNotifcation(id);
                                                  LocalNotificationService
                                                      .showScheduledNotification(
                                                          id: id,
                                                          title: "Reminder",
                                                          body:
                                                              "Time to complete your habit ${habit.name}",
                                                          scheduledTime: habit
                                                              .dailyReminderTime!);
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              size: 22,
                                              color: Colors.amberAccent[200],
                                            )),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 10),
                        ],
                      )
                    : const SizedBox(),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[900]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.create,
                              color: habit.color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Created on ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            DateFormat.yMMMd('en_US')
                                .format(habit.habitStartDate),
                            style: TextStyle(
                                color: habit.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<TimeOfDay?> showHabitTimePicker(
    {Habit? habit, required BuildContext context}) {
  DateTime initialTime = DateTime.now();
  if (habit != null) {
    initialTime = habit.dailyReminderTime ?? DateTime.now();
  }
  return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime));
}

Habit? getHabitWithName(Box box, String name) {
  Habit? habit;
  for (var key in box.keys) {
    if (key.contains(name)) {
      habit = box.get(key);
      break;
    }
  }
  return habit;
}
