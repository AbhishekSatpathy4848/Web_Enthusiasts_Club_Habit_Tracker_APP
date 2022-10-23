import 'package:flutter/material.dart';
import 'package:habit_tracker/Habit.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:habit_tracker/pages/login_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 1;
  final screen = [const HabitList(),const Login()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],      
      appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("Habit Tracker"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                    
                },
                icon: const Icon(Icons.add_circle_outline))
          ],
        ),
        body: screen[index],
        bottomNavigationBar: 
        // NavigationBarTheme(
        //   data: NavigationBarThemeData(
        //       labelTextStyle: MaterialStateProperty.all(
        //           const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          // child: 
          BottomNavigationBar(
            // backgroundColor: Colors.red,
            type: BottomNavigationBarType.shifting,
            currentIndex: index,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            // height: 60,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",backgroundColor: Colors.amber),
              BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: "Stats",backgroundColor: Colors.blue)
            ],
            onTap: (value) {
              setState(() {
                  index = value;
              });
            },
          ),
        // ),
        
        // body: Padding(
        //   padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
        //   child: ListView.builder(
        //     itemCount: habits.length,
        //     itemBuilder: ((context, index) {
        //       return SizedBox(
        //         height: 80,
        //         child: Card(
        //           // clipBehavior: Clip.antiAlias,
        //           shape: (RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20.0),
        //             // side: BorderSide(color: Colors.amberAccent[200]!)
        //           )),
        //           color: Colors.grey[800],
        //           child: Row(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               // Container(
        //               //   color: Colors.amber,
        //               //   child: Text(""),
        //               //   width: 10,
        //               // ),
        //               Text(habits[index].name!),
        //             ],
        //           ),
        //         ),
        //       );
        //     }),
        //   ),
        // )
        );
  }
}
