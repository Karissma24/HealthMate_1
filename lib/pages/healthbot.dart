import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../db/ai_helper.dart';
import '../db/consultation_helper.dart';

class HealthBot extends StatefulWidget {
  const HealthBot({super.key});

  @override
  State<HealthBot> createState() => _HealthBotState();
}

class _HealthBotState extends State<HealthBot> {
  final TextEditingController _symptomsController = TextEditingController();
  final AIHelper aiHelper = AIHelper();
  final HealthMateConsultationDB consultationDB = HealthMateConsultationDB();

  DateTime? _symptomStartDate;
  String _selectedPainLevel = '1';
  String _aiDiagnosis = '';
  bool _isLoading = false;

  Future<void> _submitConsultation() async {
    final String symptoms = _symptomsController.text.trim();

    if (symptoms.isEmpty || _symptomStartDate == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final String diagnosis;

    try {
      diagnosis = await aiHelper.getAIDiagnosis(symptoms);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error getting AI diagnosis: $e")));
      setState(() => _isLoading = false);
      return;
    }

    if (!mounted) return;

    setState(() {
      _aiDiagnosis = diagnosis;
      _isLoading = false;
    });

    try {
      if (kIsWeb) return;

      await consultationDB.logConsultation(
        1,
        "$symptoms\n(Pain level: $_selectedPainLevel/10)",
        diagnosis,
        _symptomStartDate!.toIso8601String(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving to database: $e")));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _symptomStartDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start a Consultation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Describe your symptoms:"),
                const SizedBox(height: 8),
                TextField(
                  controller: _symptomsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "e.g. I have a sore throat and mild cough...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("When did the symptoms start?"),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _symptomStartDate == null
                        ? "Select date"
                        : _symptomStartDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                const SizedBox(height: 16),
                const Text("How bad is your pain? (1 = mild, 10 = worst)"),
                Slider(
                  value: double.parse(_selectedPainLevel),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _selectedPainLevel,
                  onChanged: (value) {
                    setState(() {
                      _selectedPainLevel = value.toStringAsFixed(0);
                    });
                  },
                ),
                Text(
                  "Selected pain level: $_selectedPainLevel",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _submitConsultation,
                          child: const Text("Get AI Diagnosis"),
                        ),
                    const SizedBox(width: 12),

                    SizedBox(
                      width: 80,
                      height: 100,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset('lib/Images/HeailoPencil.png'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                if (_aiDiagnosis.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AI Diagnosis:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_aiDiagnosis, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
