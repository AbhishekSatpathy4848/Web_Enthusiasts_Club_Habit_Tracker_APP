import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/localNotificationService.dart';
import 'package:habit_tracker/pages/HabitList.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';

class Login extends StatelessWidget {
  Login({super.key});

  // Future<FirebaseApp> _initializeFirebase() async {
  Future signIn(context) async {
    try {
      print("Inside Sign in");
      WidgetsFlutterBinding.ensureInitialized();
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Logging in...'),
      //   // duration: Duration(days: 365),
      // ));
      // await Hive.initFlutter();
      // bool ans = await Hive.boxExists("habits");
      // print("does box exits? ${await Hive.boxExists("habits")}");
      // await Hive.deleteFromDisk().then((value) => print("deleted"));
      // ans = await Hive.boxExists("habits");
      // print("does box exits? ${await Hive.boxExists("habits")}");
      // await Hive.openBox<Habit>('habits');
      // await Hive.openBox<Habit>('completedHabits');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // ScaffoldMessenger.of(context).removeCurrentSnackBar();
      await Boxes.fillHive();
      initialiseNotificationsForFetchedHabits();
      // .then((_) {
      // navigator.pop();s
      print("Done-login filling Hive");
      // });

      //close dialog
      // Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      print(error.code);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (error.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid Email!!')));
      } else if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found!!')));
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect Password!!')));
      } else if (error.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please connect to the internet!!')));
      }
    } catch (e) {
      //ScaffoldMessenger.of(context).removeCurrentSnackBar();
      print("During Login");
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String email = '';

  String password = '';

  ValueNotifier<bool> signingIn = ValueNotifier<bool>(false);

  // loadingHabitsDialog(context) {
  //   showDialog(
  //       context: context,
  //       builder: ((context) {
  //         return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //             child: Dialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(15.0)),
  //               backgroundColor: Colors.grey[900],
  //               child: const Padding(
  //                 padding: EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 30.0),
  //                 child: Text("Loading Habits...",
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
  //               ),
  //             ));
  //       }));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
            backgroundBlendMode: BlendMode.colorBurn,
            gradient: LinearGradient(
              tileMode: TileMode.repeated,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.amber,
                Color.fromRGBO(40, 40, 40, 1),
                Colors.amber,
                Colors.red
              ],
            )
            // color: Colors.grey[900],
            ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Sign in to track your Habits",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  fontFeatures: [
                                    FontFeature.stylisticSet(6),
                                  ]),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be left blank';
                                }
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              style: const TextStyle(
                                  // color: Colors.grey[600]
                                  ),
                              decoration: getInputDecoration(
                                  "Email",
                                  "Please enter your email",
                                  const Icon(Icons.email)),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be left blank';
                                } else {
                                  return null;
                                }
                              }),
                              controller: passwordController,
                              obscureText: true,
                              decoration: getInputDecoration(
                                  'Password',
                                  'Please enter your password',
                                  const Icon(Icons.lock)),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: ValueListenableBuilder(
                                  valueListenable: signingIn,
                                  builder: (context, value, child) {
                                    return value
                                        ? Lottie.asset(
                                            'lottie/loading_lottie.json',
                                            fit: BoxFit.scaleDown,
                                            height: 100,
                                            width: 100)
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 22.0),
                                            child: RawMaterialButton(
                                              // padding: const EdgeInsets.fromLTRB(
                                              //     0, 10, 0, 10),
                                              onPressed: () {
                                                email =
                                                    emailController.text.trim();
                                                password = passwordController
                                                    .text
                                                    .trim();
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  signingIn.value = true;
                                                  signIn(context).then((value) {
                                                    signingIn.value = false;
                                                  });
                                                }
                                              },
                                              fillColor: Colors
                                                  .amberAccent[200]!,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40.0,
                                                        vertical: 15.0),
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                        Icons.app_registration,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text("Sign In",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18)),
                                                    ]),
                                              ),
                                            ),
                                          );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Not registered yet?",
                                style: TextStyle(fontSize: 15)),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.amberAccent[200]!
                                          .withOpacity(0.9),
                                      fontSize: 15),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

initialiseNotificationsForFetchedHabits() {
  final List<Habit> habits = Hive.box<Habit>('habits').values.toList();
  for (Habit habit in habits) {
    if (habit.dailyReminderTime != null) {
      LocalNotificationService.showScheduledNotification(
          id: generateUniqueNotficationId(habit),
          title: "Reminder",
          body: "Time to complete your habit ${habit.name}",
          scheduledTime: habit.dailyReminderTime!);
    }
  }
}

InputDecoration getInputDecoration(String label, String hint, Icon icon) {
  return InputDecoration(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      floatingLabelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white60, width: 0.8),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      helperStyle: const TextStyle(color: Colors.amber),
      suffixIconColor: Colors.amber,
      suffixIcon: icon,
      labelText: label,
      hintText: hint);
}

final emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
