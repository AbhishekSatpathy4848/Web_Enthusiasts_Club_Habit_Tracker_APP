import 'package:flutter/material.dart';
import 'package:activity_ring/activity_ring.dart';
import 'package:habit_tracker/model/Habit.dart';

class Rings extends StatelessWidget {
  Rings(this.habit,{super.key});
  late Habit habit;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 280,
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
                          percent: habit.getProgressRate().toDouble(),
                          color: RingColorScheme(
                              ringColor:
                                  Color.fromRGBO(249, 17, 79, 1)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text(
                                  "${habit.getProgressRate().toString()}%",
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
                          percent: habit.getSuccessRate().toDouble(),
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromARGB(255, 15, 232, 127)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text(
                                  "${habit.getSuccessRate().toString()}%",
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
}
