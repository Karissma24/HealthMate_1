import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthmate1/components/healthjournal/moodwidget.dart';
import 'package:healthmate1/components/healthjournal/SharedPreferencesService.dart';
import 'package:healthmate1/components/healthjournal/dailyquestions.dart';


class HealthJournal extends StatefulWidget {
  const HealthJournal({super.key});

  @override
  _HealthJournalState createState() => _HealthJournalState();
}

class _HealthJournalState extends State<HealthJournal> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferencesService.init();
    _loadResponses();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _loadResponses();
    });
  }

  Future<void> _loadResponses() async {
    String dateKey = _selectedDate.toIso8601String().split("T")[0];
    _sleepController.text = SharedPreferencesService.getString('sleep_$dateKey');
    _energyController.text = SharedPreferencesService.getString('energy_$dateKey');
  }

  Future<void> _saveResponses() async {
    String dateKey = _selectedDate.toIso8601String().split("T")[0];
    await SharedPreferencesService.setString('sleep_$dateKey', _sleepController.text);
    await SharedPreferencesService.setString('energy_$dateKey', _energyController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Responses saved for $dateKey")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "My Health Journal",
        style: GoogleFonts.fredoka(
            color: Colors.white ,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF8888e8),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2100),
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: _onDaySelected,
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
              Text(
              "Mood for the Day",
              style: GoogleFonts.fredoka(
                textStyle: TextStyle(
                  color:Color.fromARGB(255, 72, 72, 120),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                    ),
                  ),
              ),
                  SizedBox(height: 10),
                  MoodWidget(selectedDate: _selectedDate),
                
                ]
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Daily Check-in",
              style: GoogleFonts.fredoka(
                textStyle: TextStyle(
                  color:Color.fromARGB(255, 72, 72, 120),
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                    ),
                  ),
              ),
            SizedBox(height: 10),
            TextField(
              controller: _sleepController,
              decoration: InputDecoration(
                labelText: "What is one thing you wish to accomplish today?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _energyController,
              decoration: InputDecoration(
                labelText: "What can you do to feel better today?",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveResponses,
              child: Text(
                "Save Responses",
                style: GoogleFonts.fredoka(
                textStyle: TextStyle(
                  color:Color.fromARGB(255, 72, 72, 120),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                    ),
                  ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyQuestions(selectedDate: _selectedDate),
                    ),
                  );
                },
                child: Text(
                  "Daily Questions",
                  style: GoogleFonts.fredoka(
                  textStyle: TextStyle(
                  color:Color.fromARGB(255, 72, 72, 120),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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