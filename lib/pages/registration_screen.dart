import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // String userName = '';
  // String password = '';
  // String confirmPassword = '';

  Future registerUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Text('$userName and $password'),
            const SizedBox(height: 20),
            TextFormField(
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  return null;
                }
              }),
              controller: userNameController,
              style: const TextStyle(
                  // color: Colors.grey[600]
                  ),
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter Your Name',
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
                  return 'Please enter some text';
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
            TextFormField(
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  return null;
                }
              }),
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
                hintText: 'Enter Your Password',
              ),
            ),
            const SizedBox(height: 30),
            RawMaterialButton(
              onPressed: () async {
                // if(passwordController.text.trim().isNotEmpty == confirmPasswordController.text.trim().isNotEmpty){
                if (passwordController.text.trim() ==
                    confirmPasswordController.text.trim()) {
                  if (passwordController.text.trim().length >= 6) {
                    await registerUser();
                    Navigator.of(context).pop();
                  }else{
                      Fluttertoast.showToast(
                      msg: "Passwords should be more than 6 characters long!!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER);
                    }
                } else {
                  Fluttertoast.showToast(
                    msg: "Passwords don't Match!!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
