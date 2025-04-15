import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(color: Color(0xffd4a5c2)),
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
                  border: Border.all(color: const Color(0xff004aad), width: 3),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: screenHeight * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff9e31bd),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "It's great to see you again!",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF0093c1),
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
              bottom: screenHeight * 0.00,
              right: screenWidth * 0.00,
              child: Image.asset(
                'assets/talkingflower.PNG',
                height: 230,
                width: 230,
              ),
            ),

            // Inputting Email
            Positioned(
              top: screenHeight * 0.35,
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
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(Icons.mail, color: Color(0xffb1deef)),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xffb1deef)),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffb1deef),
                  ),
                ),
              ),
            ),

            // Inputting Password
            Positioned(
              top: screenHeight * 0.44,
              left: screenWidth * 0.15,
              right: screenWidth * 0.15,
              child: Container(
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  color: const Color(0xFF9e31bd),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color(0xFF9e31bd)),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(Icons.lock, color: Color(0xffb1deef)),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Color(0xffb1deef)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(Icons.visibility, color: Color(0xffb1deef)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffb1deef),
                  ),
                ),
              ),
            ),

            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.33,
              right: screenWidth * 0.33,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/passwordreset");
                },
                child: Text(
                  "Forgot password?",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Color(0xFF0093c1),
                  ),
                ),
              ),
            ),

            // Submit Button
            Positioned(
              top: screenHeight * 0.56,
              left: screenWidth * 0.33,
              right: screenWidth * 0.33,
              child: GestureDetector(
                onTap: signIn,
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: const Color(0xffb1deef),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
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

            Positioned(
              bottom: screenHeight * 0.01,
              left: screenWidth * 0.35,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: Text(
                  "Create Account",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    color: Color(0xFF0093c1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return null;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(e.message.toString()));
        },
      );
      return null;
    }
  }

  void signIn() async {
    // Call the sign-in function and await result
    User? user = await signInWithEmailAndPassword(
      context,
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    // If user is authenticated, navigate to the home screen
    if (user != null) {
      Navigator.pushNamed(context, '/home');
    }
  }
}
