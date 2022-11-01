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
        height: 220,
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Ring(
                          percent: habit.progressRate.toDouble(),
                          color: RingColorScheme(
                              ringColor:
                                  const Color.fromRGBO(249, 17, 79, 1)),
                          width: 15,
                          radius: 50,
                          child: Center(
                              child: Text(
                                  "${habit.progressRate.toString()}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16,fontWeight: FontWeight.w500))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Progress Rate",
                          style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w900),
                        )
                      ]),
                  const SizedBox(width: 50),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Text(
                                  "${habit.successRate.toString()}%",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16,fontWeight: FontWeight.w500))),
                        ),
                        // ),
                        const SizedBox(height: 70),
                        const Text(
                          "Success Rate",
                          style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w900),
                        )
                      ]),
                ]),
              ],
            )));
  }
}
