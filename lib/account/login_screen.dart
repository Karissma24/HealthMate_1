import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xffd4a5c2)),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Image(
                image: AssetImage('assets/healthMateLogo.PNG'),
                height: 350,
                width: 350,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome!',
              style: GoogleFonts.playfairDisplay(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9e31bd),
              ),
            ),
            const SizedBox(height: 30),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Color(0xFF9e31bd),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xFF9e31bd)),
                ),
                child: Center(
                  child: Text(
                    'SIGN IN',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Color(0xFF9e31bd),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xFF9e31bd)),
                ),
                child: Center(
                  child: Text(
                    'SIGN UP',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
