import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:habit_tracker/boxes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:habit_tracker/pages/HabitDetailsPage.dart';
import 'package:habit_tracker/pages/CompletedHabitsPage.dart';
import 'package:habit_tracker/FirebaseRealtime/write.dart';
import 'package:hive/hive.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print("Entered Profile build");
    return Scaffold(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  // width: MediaQuery.of(context).size.width,
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
                      title: Row(
                        children: const [
                          SizedBox(width: 10),
                          Text(
                            "Show Completed Habits",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.green,
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
                        vertical: 20, horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(width: 10),
                        const Text("Your Email ID:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromRGBO(255, 192, 29, 1))),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(user == null ? "NULL" : user!.email.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white)),
                        const Spacer(),
                        const Icon(Icons.mail_outline, color: Colors.red)
                      ],
                    ),
                  )),
              const SizedBox(height: 15),
              RawMaterialButton(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                onPressed: () async {
                  try {
                    print("Sign out pressed 1");
                    final currentUID = FirebaseAuth.instance.currentUser!.uid;
                    // if (FirebaseAuth.instance.currentUser != null) {
                    //   currentUID = FirebaseAuth.instance.currentUser!.uid;
                    // } else {
                    //   currentUID = null;
                    //   print("UID is null");
                    // }
                    print("Sign out pressed 2");
                    writeToDatabase(currentUID);
                    // Navigator.pop(context);
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    print("Error in Profile Page");
                  }
                },
                fillColor: const Color.fromRGBO(40, 40, 40, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text("Sign Out",
                          style: TextStyle(color: Colors.blue, fontSize: 18)),
                    ]),
              ),
            ],
          ),
        ));
  }
}
