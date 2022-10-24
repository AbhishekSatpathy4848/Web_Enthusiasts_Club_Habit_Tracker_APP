import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //   return firebaseApp;
  // }

  Future signIn() async {
    print("ewew");
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim());
    print("heuifr");
  }

  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('$userName and $password'),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    print(1);
                    return 'Please enter some text';
                  } else {
                    print(2);
                    return null;
                  }
                },
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
              RawMaterialButton(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                onPressed: () {
                  setState(() {
                    userName = userNameController.text.trim();
                    password = passwordController.text.trim();
                    // rint("ewybgyw");
                    signIn();
                  });
                },
                fillColor: Colors.blue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.lock_open,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text("Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ]),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
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
                        // Navigator.pushNamed(context, '/register');
                      },
                      child: const Text("Create Account"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
