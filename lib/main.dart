import 'package:flutter/material.dart';
import 'db/ai_helper.dart';
import 'secrets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("API Key Loaded from secrets.dart: ${Secrets.openAiApiKey}");

  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AITestScreen(),
    );
  }
}

class AITestScreen extends StatefulWidget {
  const AITestScreen({super.key});

  @override
  AITestScreenState createState() => AITestScreenState();
}

class AITestScreenState extends State<AITestScreen> {
  final AIHelper aiHelper = AIHelper();
  final TextEditingController symptomsController = TextEditingController();
  String _aiDiagnosis = "Waiting for AI Diagnosis...";

  void _getDiagnosis() async {
    String symptoms = symptomsController.text;
    if (symptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your symptoms!")),
      );
      return;
    }

    setState(() {
      _aiDiagnosis = "AI is analyzing symptoms...";
    });

    String diagnosis = await aiHelper.getAIDiagnosis(symptoms);

    setState(() {
      _aiDiagnosis = diagnosis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HealthMate AI Diagnosis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: symptomsController,
              decoration: const InputDecoration(labelText: "Enter Symptoms"),
            ),
            ElevatedButton(
              onPressed: _getDiagnosis,
              child: const Text("Get AI Diagnosis"),
            ),
            const SizedBox(height: 20),
            Text(
              _aiDiagnosis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

