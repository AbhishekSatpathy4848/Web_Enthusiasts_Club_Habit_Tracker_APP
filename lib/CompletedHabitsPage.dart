import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/pages/HabitDetailsPage.dart';

class CompletedHabitsPage extends StatelessWidget {
  const CompletedHabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Completed Habits",style: TextStyle(color: Colors.amberAccent[200])),
        centerTitle: true,),
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 0.0),
        child: ListView.builder(
                        itemCount: Boxes.getCompletedHabits().values.length,
                        itemBuilder: ((context, index) {
                          final completedHabits =
                              Boxes.getCompletedHabits().values.toList();
                          return Card(
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
                                                    completedHabits[index].name.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
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
                                                color: completedHabits[index].color),
                                          ),
                                          onTap: (() {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: ((context) =>
                                                        HabitDetailsPage(
                                                            completedHabits[index]))));
                                            // Navigator.push(context, )
                                          }),
                                          trailing:  const Icon(Icons.check_circle_outline_outlined,color: Colors.green,size: 30,),
                                         ));
    
                        })),
      ),
    );
  }
}