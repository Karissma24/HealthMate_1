import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters.")),
      );
      return;
    }

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign Up Failed"),
            content: Text(e.message ?? "An unknown error occurred."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    }
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: const Color(0xFF9e31bd),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF9e31bd)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(icon, color: const Color(0xffb1deef)),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xffb1deef)),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          border: InputBorder.none,
        ),
        style: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xffb1deef),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            width: screenWidth,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xffc5c5ff),
                border: Border.all(color: const Color(0xff004aad), width: 3),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: screenHeight * 0.05,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff9e31bd),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Happy to see a new face!",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: screenHeight * 0.035,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF0093c1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Decorative assets
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.07,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Image.asset('assets/back.PNG', height: 90, width: 90),
            ),
          ),
          Positioned(
            top: screenHeight * 0.01,
            right: screenWidth * 0.02,
            child: Image.asset('assets/flowers.PNG', height: 150, width: 150),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/talkingflower2.PNG', height: 230, width: 230),
          ),

          // Input Fields
          Positioned(
            top: screenHeight * 0.35,
            left: screenWidth * 0.15,
            right: screenWidth * 0.15,
            child: buildInputField(
              controller: _usernameController,
              hintText: 'Username',
              icon: Icons.person,
            ),
          ),
          Positioned(
            top: screenHeight * 0.44,
            left: screenWidth * 0.15,
            right: screenWidth * 0.15,
            child: buildInputField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.mail,
            ),
          ),
          Positioned(
            top: screenHeight * 0.53,
            left: screenWidth * 0.15,
            right: screenWidth * 0.15,
            child: buildInputField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock,
              obscureText: !isVisible,
              suffixIcon: IconButton(
                onPressed: () => setState(() => isVisible = !isVisible),
                icon: const Icon(Icons.visibility, color: Color(0xffb1deef)),
              ),
            ),
          ),

          // Submit
          Positioned(
            top: screenHeight * 0.62,
            left: screenWidth * 0.33,
            right: screenWidth * 0.33,
            child: GestureDetector(
              onTap: signUp,
              child: Container(
                height: screenHeight * 0.045,
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

          // Sign In link
          Positioned(
            bottom: screenHeight * 0.01,
            left: screenWidth * 0.43,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, "/signin"),
              child: Text(
                "Sign In",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                  color: const Color(0xFF0093c1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
