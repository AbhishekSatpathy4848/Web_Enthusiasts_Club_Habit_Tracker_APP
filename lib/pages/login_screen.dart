import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
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
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/BackgroundStars.jpeg') as ImageProvider,fit: BoxFit.cover)),

        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Welcome Back!!",style: TextStyle(color:  Color.fromARGB(255, 237, 183, 5),fontWeight: FontWeight.bold,fontSize: 38,letterSpacing: 1.2),textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                Text("Let's Build some tiny habits!",style: TextStyle(color:  Colors.blue,fontWeight: FontWeight.bold,fontSize: 30,letterSpacing: 1.2),textAlign: TextAlign.center,),
      
                const SizedBox(height: 30),
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
                RawMaterialButton(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  onPressed: () {
                      // email = emailController.text.trim();
                      // password = passwordController.text.trim();
                      signIn();
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
                            style: TextStyle(color: Colors.white, fontSize: 18)),
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
