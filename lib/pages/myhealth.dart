import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHealth extends StatefulWidget {
  const MyHealth({super.key});

  @override
  State<MyHealth> createState() => _MyHealthState();
}

class _MyHealthState extends State<MyHealth> {
  final TextEditingController waterController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController exerciseController = TextEditingController();
  List<String> exerciseLog = [];

  int seconds = 0;
  Timer? timer;
  bool isRunning = false;

  String userId = 'default';

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? 'default';
    _loadGoals();
  }

  void _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterController.text = prefs.getString('${userId}_goal_water') ?? '';
      stepsController.text = prefs.getString('${userId}_goal_steps') ?? '';
      exerciseLog = prefs.getStringList('${userId}_exercise_log') ?? [];
    });
  }

  void _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${userId}_goal_water', waterController.text);
    await prefs.setString('${userId}_goal_steps', stepsController.text);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Goals saved!")));
  }

  void _startPauseTimer() {
    if (isRunning) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          seconds++;
        });
      });
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void _resetTimer() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isRunning = false;
    });
  }

  void _addExercise() async {
    if (exerciseController.text.isNotEmpty) {
      setState(() {
        exerciseLog.add(exerciseController.text);
        exerciseController.clear();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('${userId}_exercise_log', exerciseLog);
    }
  }

  void _clearExerciseLog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${userId}_exercise_log');
    setState(() {
      exerciseLog.clear();
    });
  }

  @override
  void dispose() {
    waterController.dispose();
    stepsController.dispose();
    exerciseController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Health",
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF8888e8),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard("My Goals", [
                _buildTextField(waterController, "Water Goal (oz) "),
                _buildTextField(stepsController, "Step Goal 👣"),
                ElevatedButton(
                  onPressed: _saveGoals,
                  child: Text(
                    "Save Goals",
                    style: GoogleFonts.fredoka(color: Color(0xFF333354)),
                  ),
                ),
              ]),
              SizedBox(height: 20),

              _buildCard("Timer ⏱️", [
                Text(
                  "Elapsed: ${Duration(seconds: seconds).toString().split('.').first}",
                  style: GoogleFonts.fredoka(fontSize: 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _startPauseTimer,
                      child: Text(
                        isRunning ? "Pause" : "Start",
                        style: GoogleFonts.fredoka(color: Color(0xFF333354)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _resetTimer,
                      child: Text(
                        "Reset",
                        style: GoogleFonts.fredoka(color: Color(0xFF333354)),
                      ),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 20),

              _buildCard("Exercise Log 💪", [
                _buildTextField(exerciseController, "Enter Exercise"),
                ElevatedButton(
                  onPressed: _addExercise,
                  child: Text(
                    "Add Exercise",
                    style: GoogleFonts.fredoka(color: Color(0xFF333354)),
                  ),
                ),
                if (exerciseLog.isNotEmpty)
                  ElevatedButton(
                    onPressed: _clearExerciseLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "Clear Log",
                      style: GoogleFonts.fredoka(color: Colors.white),
                    ),
                  ),
                ...exerciseLog.map(
                  (e) => ListTile(title: Text(e, style: GoogleFonts.fredoka())),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333354),
              ),
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        style: GoogleFonts.fredoka(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.fredoka(),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
