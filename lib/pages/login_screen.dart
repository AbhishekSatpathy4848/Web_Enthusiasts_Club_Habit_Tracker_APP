import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/ColorAdapter.dart';

class Login extends StatelessWidget {
  Login({super.key});

  // Future<FirebaseApp> _initializeFirebase() async {
  void signIn(context) async {
    try {
      print("Inside Sign in");
      WidgetsFlutterBinding.ensureInitialized();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logging in...'),
        duration: Duration(days: 365),
      ));
      // await Hive.initFlutter();
      // bool ans = await Hive.boxExists("habits");
      // print("does box exits? ${await Hive.boxExists("habits")}");
      // await Hive.deleteFromDisk().then((value) => print("deleted"));
      // ans = await Hive.boxExists("habits");
      // print("does box exits? ${await Hive.boxExists("habits")}");
      await Hive.openBox<Habit>('habits');
      await Hive.openBox<Habit>('completedHabits');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      print("Called-login filling hive");
      await Boxes.fillHive();
      print("Done-login filling Hive");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      print("During Login");
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/BackgroundStars.jpeg'),
                fit: BoxFit.cover)),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "Welcome Back!!",
                  style: TextStyle(
                      color: Color.fromARGB(255, 237, 183, 5),
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      letterSpacing: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Let's Build some tiny habits!",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be left blank';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  style: const TextStyle(
                      // color: Colors.grey[600]
                      ),
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Your Email',
                      labelStyle: TextStyle(
                          // fontWeight: FontWeight.bold,
                          // color: Colors.amberAccent[200],
                          // fontSize: 24
                          )),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be left blank';
                    } else {
                      return null;
                    }
                  }),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Your Password',
                  ),
                ),
                const SizedBox(height: 30),
                RawMaterialButton(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  onPressed: () {
                    // email = emailController.text.trim();
                    // password = passwordController.text.trim();
                    if (_formKey.currentState!.validate()) {
                      signIn(context);
                    }
                  },
                  fillColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text("Sign In",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ]),
                ),
                Row(
                  children: [
                    const Text("Not registered yet?"),
                    TextButton(
                        onPressed: () {
                          // if (_formKey.currentState!= null) {
                          //   if(_formKey.currentState!.validate())
                          //     return;
                          // }
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("Create Account"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
