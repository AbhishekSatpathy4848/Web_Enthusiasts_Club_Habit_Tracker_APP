import 'package:flutter/material.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:intl/intl.dart';

class BestStreakWidget extends StatelessWidget {
  BestStreakWidget(this.habit, {super.key});
  late Habit habit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/Fire.png',width: 60,height: 60),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const Text("BEST STREAK",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),const SizedBox(height: 10),Text(habit.maxStreaks== 1 ? "${habit.maxStreaks} day" : "${habit.maxStreaks} days",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)],
        ),
        // const SizedBox(width: 50),
        const Spacer(),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: const Color.fromRGBO(62, 62, 62, 1)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("FROM ${DateFormat.yMMMd('en_US').format(habit.bestStreakStartDate)}",style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500),),
          ),
        ),
        const SizedBox(width: 8,)
        
      ],
    );
  }
}
