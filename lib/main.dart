import 'Pages/homepage.dart';
import 'Pages/hospitals.dart';
import 'Pages/myhealth.dart';
import 'Pages/setting.dart';
import 'Pages/healthjournal.dart';
import 'Pages/healthbot.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      routes: {
        '/HomePage': (context) => Homepage(),
        '/Hospitals': (context) => Hospitals(),
        '/HealthJournal': (context) => HealthJournal(),
        '/HealthBot': (context) => HealthBot(),
        '/MyHealth': (context) => MyHealth(),
        '/Settings': (context) => Settings(),
      },
    );
  }
}

  }
}

