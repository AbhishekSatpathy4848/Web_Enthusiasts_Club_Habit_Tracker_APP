import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/backup.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/pages/Home.dart';
import 'package:habit_tracker/pages/login_screen.dart';
import 'package:habit_tracker/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/provider_shared_state.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/ColorAdapter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<Habit>('completedHabits');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? lastBackedUpDate = prefs.getString("lastBackUpDate");

  runApp(
    MaterialApp(
      home: LoginCheck(lastBackedUpDate: lastBackedUpDate),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Registration(),
        '/home': (context) => const Home(),
      },
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) => ChangeNotifierProvider(
          create: (context) {
            return SharedState(lastBackedUp: lastBackedUpDate);
          },
          child: child),
    ),
  );
}

class LoginCheck extends StatelessWidget {
  final String? lastBackedUpDate;
  const LoginCheck({this.lastBackedUpDate, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                  initialiseCronJob(
                    FirebaseAuth.instance.currentUser!.uid, context);
                return const Home();
              } else if (snapshot.hasError) {
                Fluttertoast.showToast(
                  msg: "There was an Error in Logging you in!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                return Login();
              } else {
                // print("No Data");
                return Login();
              }
            }));
  }
}
