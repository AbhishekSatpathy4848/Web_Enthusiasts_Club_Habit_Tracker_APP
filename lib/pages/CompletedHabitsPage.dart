import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/pages/HabitDetailsPage.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CompletedHabitsPage extends StatelessWidget {
  const CompletedHabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Completed Habits",
            style: TextStyle(color: Colors.amberAccent[200])),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
        child: ValueListenableBuilder(
            valueListenable: Hive.box<Habit>("completedHabits").listenable(),
            builder: ((context, box, child) {
              List<Habit> completedHabits = box.values.toList();
              return completedHabits.isEmpty
                  ? const Center(
                      child: Text(
                        "No Completed Habits!!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )
                  : ListView.builder(
                      itemCount: completedHabits.length,
                      itemBuilder: ((context, index) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: const Color.fromRGBO(40, 40, 40, 1),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        completedHabits[index].name.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Container(
                                  width: 10,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: completedHabits[index].color),
                                ),
                                onTap: (() {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: ((context) =>
                                              HabitDetailsPage(
                                                  habit: completedHabits[
                                                      index]))));
                                }),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color:
                                              Color.fromARGB(255, 225, 90, 78)),
                                      onPressed: (){
                                          showDeleteHabitDialog(deleteHabit, context, completedHabits[index]);
                                      }
                                    )
                                  ],
                                ),
                              ),
                            ));
                      }));
            })),
      ),
    );
  }
}

deleteHabit(Habit habit) {
  habit.delete();
}
