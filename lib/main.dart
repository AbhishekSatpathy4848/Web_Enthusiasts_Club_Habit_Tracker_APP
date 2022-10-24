import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/Habit.dart';
import 'package:habit_tracker/pages/Home.dart';
import 'package:habit_tracker/pages/login_screen.dart';
import 'package:habit_tracker/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final Future<FirebaseApp> _fbApp = await Firebase.initializeApp();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: MainPage(),
    // home:
    // future: _fbApp,
    // builder: ((context, snapshot) {
    //   if (snapshot.hasError) {
    //     print('You have an error! ${snapshot.error.toString()}');
    //     return const Text('Something went wrong!!');
    //   } else if (snapshot.hasData) {
    //     return Login();
    //   } else {
    //     return const Center(child: CircularProgressIndicator());
    //   }
    // }),
    // Scaffold(
    //     body: StreamBuilder<User?>(
    //         stream: FirebaseAuth.instance.authStateChanges(),
    //         builder: ((context, snapshot) {
    //           if (snapshot.hasData) {
    //             print("here");
    //             return Home();
    //           } else {
    //             print("here1");
    //             return Registration();
    //           }
    //         }))),
    // initialRoute: '/home',
    // routes: {
    //   '/login': (context) => Login(),
    //   '/register': (context) => Registration(),
    //   '/home':(context) => Home(),
    // },
  ));
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                print("Login Successful");
                return Home();
              } else {
                // print("No Data");
                return Login();
              }
            })));
  }
}
