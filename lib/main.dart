import 'package:flutter/material.dart';
import 'package:healthmate1/pages/healthjournal.dart';
import 'package:healthmate1/pages/healthbot.dart';
import 'package:healthmate1/pages/homepage.dart';
import 'package:healthmate1/pages/myhealth.dart';
import 'package:healthmate1/pages/settings.dart';
//import 'package:provider/provider.dart';
import 'package:healthmate1/components/healthjournal/SharedPreferencesService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Mate',
      initialRoute: '/HomePage',
      routes: {
        '/HomePage': (context) => const Homepage(),
        '/HealthJournal': (context) => HealthJournal(),
        '/HealthBot': (context) => const HealthBot(),
        '/MyHealth': (context) => const MyHealth(),
        '/Settings': (context) => const Settings(),
        //'/Hospitals' :(context) => Hospitals(),
        //'/GoogleMaps': (context) => GoogleMapFlutter()
      },
    );
  }
}
