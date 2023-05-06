import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/model/Habit.dart';
import 'package:habit_tracker/FirebaseRealtime/read.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

//update the local storage hive with data from the database

class Boxes {
  static fillHive() {
    readFromDatabase();
  }
}
