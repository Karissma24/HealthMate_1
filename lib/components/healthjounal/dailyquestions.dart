import 'package:flutter/material.dart';
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
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0];
    _goalController.text = SharedPreferencesService.getString('goal_$dateKey');
    _feelBetterController.text = SharedPreferencesService.getString('feelBetter_$dateKey');
    _laughController.text = SharedPreferencesService.getString('laugh_$dateKey');
    _sleepController.text = SharedPreferencesService.getString('sleep_$dateKey');
    _areYouOkayController.text = SharedPreferencesService.getString('areYouOkay_$dateKey');
    _stressLevelController.text = SharedPreferencesService.getString('stressLevel_$dateKey');
    _notesController.text = SharedPreferencesService.getString('notes_$dateKey');
  }

  Future<void> _saveResponses() async {
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0];
    await SharedPreferencesService.setString('goal_$dateKey', _goalController.text);
    await SharedPreferencesService.setString('feelBetter_$dateKey', _feelBetterController.text);
    await SharedPreferencesService.setString('laugh_$dateKey', _laughController.text);
    await SharedPreferencesService.setString('sleep_$dateKey', _sleepController.text);
    await SharedPreferencesService.setString('areYouOkay_$dateKey', _areYouOkayController.text);
    await SharedPreferencesService.setString('stressLevel_$dateKey', _stressLevelController.text);
    await SharedPreferencesService.setString('notes_$dateKey', _notesController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Responses saved for $dateKey")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Questions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _goalController,
                decoration: InputDecoration(
                  labelText: "What is one thing you wish to accomplish today?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _feelBetterController,
                decoration: InputDecoration(
                  labelText: "What can you do to feel better today?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _laughController,
                decoration: InputDecoration(
                  labelText: "What made you laugh today?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _sleepController,
                decoration: InputDecoration(
                  labelText: "How did you sleep last night?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _areYouOkayController,
                decoration: InputDecoration(
                  labelText: "Are you okay?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _stressLevelController,
                decoration: InputDecoration(
                  labelText: "What was your stress level today? (1-10)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: "Any other notes?",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveResponses,
                child: Text("Save Responses"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}