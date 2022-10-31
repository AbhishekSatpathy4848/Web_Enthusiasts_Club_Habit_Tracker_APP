import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/Home.dart';
import 'package:habit_tracker/pages/login_screen.dart';
import 'package:habit_tracker/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/ColorAdapter.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<Habit>('completedHabits');
  await Firebase.initializeApp();


  Fluttertoast.showToast(
                  msg: "There was an Error in Logging you in!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
  print("Hive Hive 121212");

  runApp(
    MaterialApp(
      home: LoginCheck(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Registration(),
        '/home': (context) => Home(),
      },
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
    ),
  );
}

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: CircularProgressIndicator());
              // }
              // await Hive.openBox<Habit>('habits');
            // await Hive.openBox<Habit>('completedHabits');
              
              print("hello");
              if (snapshot.hasData) {
                print("Login Successful");
                return Home();
              } else if (snapshot.hasError) {
                print("Error");
                Fluttertoast.showToast(
                  msg: "There was an Error in Logging you in!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                return Login();
              } else {
                print("No Data");
                return Login();
              }
            })));
  }
}
