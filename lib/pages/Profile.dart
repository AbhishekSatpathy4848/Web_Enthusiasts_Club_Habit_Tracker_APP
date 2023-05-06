import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/getDayDifference.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/CompletedHabitsPage.dart';
import 'package:habit_tracker/FirebaseRealtime/write.dart';
import 'package:habit_tracker/provider_shared_state.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  Profile({super.key});
  ValueNotifier<bool> backingUp = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    // print("Entered Profile build");
    return Scaffold(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color.fromRGBO(40, 40, 40, 1)),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) =>
                                    const CompletedHabitsPage()))),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          title: Row(
                            children: const [
                              Icon(
                                Icons.navigate_next,
                                color: Colors.green,
                                size: 28,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Show Completed Habits",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 15),
                  Container(
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color.fromRGBO(40, 40, 40, 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // const Text("Email ID:",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 17,
                            //         color: Color.fromRGBO(255, 192, 29, 1))),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            const Icon(Icons.mail_outline, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(user == null ? "NULL" : user!.email.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 15),
                  RawMaterialButton(
                    onPressed: () async {
                      if (backingUp.value) return;
                      backingUp.value = true;
                      final currentUID = FirebaseAuth.instance.currentUser!.uid;
                      await writeToDatabase(currentUID, context);
                      backingUp.value = false;
                    },
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    fillColor: const Color.fromRGBO(40, 40, 40, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ValueListenableBuilder(
                        valueListenable: backingUp,
                        builder: (context, value, child) {
                          return value
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Center(
                                    child: LinearProgressIndicator(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Colors.blueAccent,
                                      ),
                                      SizedBox(width: 10),
                                      Text("Sync Habits",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ]);
                        }),
                  ),
                  const SizedBox(height: 15),
                  Consumer<SharedState>(
                    builder: (context, SharedState state, child) {
                      return state.lastBackedUp == null
                          ? Container()
                          : Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: const Color.fromRGBO(
                                            40, 40, 40, 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.cloud_done_outlined,
                                              color: Colors.greenAccent),
                                          const SizedBox(width: 10),
                                          Text(state.lastBackedUp.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 15),
                              ],
                            );
                    },
                  ),
                  Consumer<SharedState>(
                    builder: (context, state, child) {
                      return Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: const Color.fromRGBO(40, 40, 40, 1)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.schedule_outlined,
                                        color: Colors.blueAccent),
                                    const SizedBox(width: 10),
                                    Text(calculateNextBackupTime(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.white)),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: backingUp,
                      builder: (context, value, child) {
                        return IgnorePointer(
                          ignoring: value,
                          child: RawMaterialButton(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            onPressed: () async {
                              try {
                                final currentUID =
                                    FirebaseAuth.instance.currentUser!.uid;
                                await writeToDatabase(currentUID, context);
                                await Hive.box<Habit>('habits').clear();
                                await Hive.box<Habit>('completedHabits')
                                    .clear();
                                await Hive.close();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();

                                await FirebaseAuth.instance.signOut();
                                print("Signed Out");
                              } catch (e) {
                                print("Error in Profile Page");
                              }
                            },
                            fillColor: const Color.fromRGBO(40, 40, 40, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.redAccent.shade200,
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Sign Out",
                                      style: TextStyle(
                                          color: Colors.redAccent.shade200,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ]),
                          ),
                        );
                      }),
                ])));
  }
}

String calculateNextBackupTime() {
  var today = DateTime.now();
  DateTime scheduledTime;
  if (today.hour >= 2 && today.minute > 30 || today.hour > 2) {
    scheduledTime = today.add(const Duration(days: 1));
  } else {
    scheduledTime = today;
  }
  return DateFormat('dd-MMMM-yyyy  02:30 a').format(scheduledTime);
}
