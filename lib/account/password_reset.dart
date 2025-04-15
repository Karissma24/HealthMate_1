import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Password reset link sent if this email exists in our system! Check your email."),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(e.message.toString()));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Color(0xffd4a5c2),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffc5c5ff),
                  border: Border.all(
                    color: const Color(0xff004aad),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 110),
                      child: Text(
                        'Password Reset',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: screenHeight * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff9e31bd),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.07,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/back.PNG', height: 90, width: 90),
              ),
            ),

            // Flower Image
            Positioned(
              top: screenHeight * 0.01,
              right: screenWidth * 0.02,
              child: Image.asset('assets/flowers.PNG', height: 150, width: 150),
            ),

            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.15,
              right: screenWidth * 0.15,
              child: Text(
                'Enter your email and we will send you a password reset link.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: screenHeight * 0.027,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xff9e31bd),
                ),
              ),
            ),

            // Inputting Email
            Positioned(
              top: screenHeight * 0.53,
              left: screenWidth * 0.15,
              right: screenWidth * 0.15,
              child: Container(
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  color: const Color(0xff9e31bd),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color(0xff9e31bd)),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.mail, color: Color(0xffb1deef)),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xffb1deef)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffb1deef)),
                ),
              ),
            ),

            // Password Reset Button
            Positioned(
              top: screenHeight * 0.62,
              left: screenWidth * 0.33,
              right: screenWidth * 0.33,
              child: GestureDetector(
                onTap: () async {
                  await passwordReset();
                },
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: const Color(0xffb1deef),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Reset Password",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF9e31bd),
                      ),
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
