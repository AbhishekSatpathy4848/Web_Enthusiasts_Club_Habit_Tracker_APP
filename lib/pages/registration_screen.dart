import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/pages/login_screen.dart';
import 'package:lottie/lottie.dart';

class Registration extends StatelessWidget {
  Registration({super.key});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> registering = ValueNotifier<bool>(false);

  // String email = '';
  Future registerUser(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Fluttertoast.showToast(
          msg: "User Registered Successfully!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_LEFT);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      print(error.code);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (error.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid Email!!')));
      } else if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Already Exists!!')));
      } else if (error.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please use a Stronger Password!!')));
      } else if (error.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please connect to the internet!!')));
      }
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Text('$email and $password'),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Begin your habit-tracking journey!",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  fontFeatures: [
                                    FontFeature.stylisticSet(6),
                                  ]),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be left blank';
                                }
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              }),
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
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: getInputDecoration(
                                  'Password',
                                  'Please enter your password',
                                  const Icon(Icons.lock)),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: ValueListenableBuilder(
                                  valueListenable: registering,
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
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  if (passwordController.text
                                                          .trim() ==
                                                      confirmPasswordController
                                                          .text
                                                          .trim()) {
                                                    registering.value = true;
                                                    registerUser(context)
                                                        .then((value) {
                                                      registering.value = false;
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Passwords don't Match!!")));
                                                  }
                                                }
                                              },
                                              fillColor:
                                                  Colors.amberAccent[200]!,
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
                                                      Text("Sign Up",
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
                            const Text("Already have an Account?",
                                style: TextStyle(fontSize: 15)),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Sign In",
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
