
import 'package:flutter/material.dart';


import 'package:healthmate1/pages/healthjournal.dart';
import 'package:healthmate1/pages/healthbot.dart';
import 'package:healthmate1/pages/homepage.dart';
import 'package:healthmate1/pages/hospitals.dart';
import 'package:healthmate1/pages/myhealth.dart';
import 'package:healthmate1/pages/settings.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      routes: {
        '/HomePage' :(context) => Homepage(),
        '/Hospitals' :(context) => Hospitals(),
        '/HealthJournal' :(context) => HealthJournal(),
        '/HealthBot' :(context) => HealthBot(),
        '/MyHealth' :(context) => MyHealth(),
        '/Settings' :(context) => Settings(),
    

      },
      );
      
  }
}
