import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd4a5c2),
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            const Text(
              "Our emails for your convenience!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),

            Image.asset(
              'assets/healthMateLogo.PNG', 
              height: 270,
              width: 270,
            ),
            const SizedBox(height: 20),

            
            const Text(
              "Alessandra Rodriguez\narodriguez148@leomail.tamuc.edu\n\n"
              "Karissma Quinones\nkquinones@leomail.tamuc.edu\n\n"
              "Caitlin Salinas\nCaitlinsalinas16@gmail.com",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}