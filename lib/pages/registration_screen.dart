import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Registration extends StatelessWidget {
  Registration({super.key});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // String email = '';
  Future registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          print("Email already registered");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey[900],
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/BackgroundStars.jpeg') as ImageProvider,fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Text('$email and $password'),
              const SizedBox(height: 20),
              TextFormField(
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                }),
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
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  onPressed: () async {
                          // if(passwordController.text.trim().isNotEmpty == confirmPasswordController.text.trim().isNotEmpty){
                  if (passwordController.text.trim() ==
                      confirmPasswordController.text.trim()) {
                    if (passwordController.text.trim().length >= 6) {
                      await registerUser();
                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Passwords should be more than 6 characters long!!",
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
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.app_registration,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text("Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 18)),
                      ]),
                // )
              ),
              Row(
                  children: [
                    const Text("Already have an Account?"),
                    TextButton(
                        onPressed: () {
                          // if (_formKey.currentState!= null) {
                          //   if(_formKey.currentState!.validate())
                          //     return;
                          // }
                          Navigator.of(context).pop();
                        },
                        child: const Text("Sign In"))
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
