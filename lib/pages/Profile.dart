import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
      children: [
          Text(user!.email!),
          RawMaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            fillColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text("Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ]),
          )
      ],
    ),
        ));
  }
}
