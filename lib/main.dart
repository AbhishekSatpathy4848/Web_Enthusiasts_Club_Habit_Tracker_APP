import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/Home.dart';
import 'package:habit_tracker/pages/login_screen.dart';
import 'package:habit_tracker/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    await Hive.openBox<Habit>('habits');

  runApp(MaterialApp(home: LoginCheck(), routes: {
    '/login': (context) => Login(),
    '/register': (context) => Registration(),
    '/home': (context) => Home(),
  }));
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
              if (snapshot.hasData) {
                // print("Login Successful");
                return const Home();
              } else if (snapshot.hasError) {
                Fluttertoast.showToast(
                  msg: "There was an Error in Logging you in!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                return const Login();
              } else {
                // print("No Data");
                return const Login();
              }
            })));
  }
}
