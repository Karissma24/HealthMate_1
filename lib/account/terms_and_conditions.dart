import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        backgroundColor: Colors.purple,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text('''
📜 Terms and Conditions

Last Updated: 04/23/2025

Welcome to our app! By using this app, you agree to the following terms:

1. Student Project
This app was created as part of a student project for App Software and Development. It is not intended for large-scale or professional use at this time.

2. Personal Use Only
This app is intended for educational and personal use only. Please do not use it for sensitive tasks or high-risk activities. Take any information you receive lightly and consult medical professionals at your discretion.

3. AI Content
Some features in this app may use AI to personalize content. We do our best to keep things accurate and appropriate, but we can’t guarantee that all AI-generated responses will be perfect or error-free.

4. Respectful Use
Don’t misuse the app — that means no reverse engineering, exploiting bugs, or using the app in a way that harms others.

🔐 Privacy Policy

1. What We Collect
We may collect the following information from you when you use the app:
- A username or nickname (if provided)
- Character customization preferences
- Optional personal details (like birthday, height, weight) if entered

This data is stored securely in Firebase Firestore, linked to your Firebase Auth user ID.

2. How We Use Your Data
We use your data to:
- Customize your profile and character
- Store preferences between sessions
- Improve the app's functionality

We do not sell your data, and we do not use your data for advertising.

3. AI and Data
If AI features are used, your inputs may be sent to a secure AI service to generate a response. We may permanently store your AI interactions.

4. Your Control
You can contact us at from the information given by accessing the messages icon on the top right side of the profile page to:
- Request deletion of your data and/or profile
- Ask questions about how we use your information

5. Security
We take reasonable steps to keep your data safe using Firebase security features, but no system is 100% secure. Use the app at your own risk.
          ''', style: TextStyle(fontSize: 16.0, height: 1.5)),
      ),
    );
  }
}
