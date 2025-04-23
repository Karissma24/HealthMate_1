import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../healthjournal/shared_preferences_service.dart';

class DailyQuestions extends StatefulWidget {
  final DateTime selectedDate;
  const DailyQuestions({super.key, required this.selectedDate});

  @override
  State<DailyQuestions> createState() => _DailyQuestionsPageState();
}

class _DailyQuestionsPageState extends State<DailyQuestions> {
  final _goalController = TextEditingController();
  final _feelBetterController = TextEditingController();
  final _laughController = TextEditingController();
  final _sleepController = TextEditingController();
  final _areYouOkayController = TextEditingController();
  final _stressLevelController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  Future<void> _loadResponses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'default';
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0];

    _goalController.text = SharedPreferencesService.getString('goal_$dateKey', userId);
    _feelBetterController.text = SharedPreferencesService.getString('feelBetter_$dateKey', userId);
    _laughController.text = SharedPreferencesService.getString('laugh_$dateKey', userId);
    _sleepController.text = SharedPreferencesService.getString('sleep_$dateKey', userId);
    _areYouOkayController.text = SharedPreferencesService.getString('areYouOkay_$dateKey', userId);
    _stressLevelController.text = SharedPreferencesService.getString('stressLevel_$dateKey', userId);
    _notesController.text = SharedPreferencesService.getString('notes_$dateKey', userId);
  }

  Future<void> _saveResponses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'default';
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0];

    await SharedPreferencesService.setString('goal_$dateKey', _goalController.text, userId);
    await SharedPreferencesService.setString('feelBetter_$dateKey', _feelBetterController.text, userId);
    await SharedPreferencesService.setString('laugh_$dateKey', _laughController.text, userId);
    await SharedPreferencesService.setString('sleep_$dateKey', _sleepController.text, userId);
    await SharedPreferencesService.setString('areYouOkay_$dateKey', _areYouOkayController.text, userId);
    await SharedPreferencesService.setString('stressLevel_$dateKey', _stressLevelController.text, userId);
    await SharedPreferencesService.setString('notes_$dateKey', _notesController.text, userId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Responses saved for $dateKey")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Questions",
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF8888e8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildQuestionField(_goalController, "What is one thing you wish to accomplish today?"),
              _buildQuestionField(_feelBetterController, "What can you do to feel better today?"),
              _buildQuestionField(_laughController, "What made you laugh today?"),
              _buildQuestionField(_sleepController, "How did you sleep last night?"),
              _buildQuestionField(_areYouOkayController, "Are you okay?"),
              _buildQuestionField(
                _stressLevelController,
                "What was your stress level today? (1-10)",
                keyboardType: TextInputType.number,
              ),
              _buildQuestionField(
                _notesController,
                "Any other notes?",
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveResponses,
                child: Text(
                  "Save Responses",
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 72, 72, 120),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
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
