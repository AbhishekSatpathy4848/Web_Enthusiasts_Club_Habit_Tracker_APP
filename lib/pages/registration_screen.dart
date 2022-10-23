import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String userName = '';
  String password = '';
  String confirmPassword = '';
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
            Text('$userName and $password'),
            const SizedBox(height: 20),
            TextFormField(
               validator: ((value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  return null;
                }
              }) ,
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
                if(value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  return null;
                }
              }) ,
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
                if(value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  return null;
                }
              }) ,
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
              onPressed: () {
                setState(() {
                  userName = userNameController.text.trim();
                  password = passwordController.text.trim();
                  confirmPassword = confirmPasswordController.text.trim();
                  if (password == confirmPassword) {
                    //TODO: Register user with Firebase
                  }
                });
              },
              fillColor: Colors.blue,
              child: const Text("Register"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ],
        ),
      ),
    );
  }
}
