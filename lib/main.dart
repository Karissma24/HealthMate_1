import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'firebase_options.dart';

// Auth & login flow
import 'account/auth.dart';
import 'account/sign_in.dart';
import 'account/sign_up.dart';
import 'account/password_reset.dart';

// Core app pages
import 'Pages/homepage.dart';
import 'Pages/myhealth.dart';
import 'Pages/setting.dart';
import 'Pages/healthjournal.dart';
import 'Pages/healthbot.dart';
import 'Pages/google_map.dart';

// Profile/customization
import 'account/profile_page.dart';
import 'account/user_cust.dart';
import 'account/contact_us.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SQLite for desktop
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const HealthMate());
}

class HealthMate extends StatelessWidget {
  const HealthMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthMate',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        // Auth flow
        "/": (context) => Auth(),
        "/signin": (context) => const SignIn(),
        "/signup": (context) => const SignUp(),
        "/passwordreset": (context) => const PasswordReset(),

        // Post-login flow
        "/home": (context) => const Homepage(),
        "/GoogleMap": (context) => const GoogleMapFlutter(),
        "/Hospitals": (context) => const GoogleMapFlutter(),
        "/HealthJournal": (context) => const HealthJournal(),
        "/HealthBot": (context) => const HealthBot(),
        "/MyHealth": (context) => const MyHealth(),
        "/Settings": (context) => const Settings(),

        // Profile & extras
        "/userprofile": (context) => const UserCust(),
        "/profilepage": (context) => const ProfilePage(),
        "/contactus": (context) => const ContactUs(),
      },
    );
  }
}
