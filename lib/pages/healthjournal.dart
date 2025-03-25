import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:healthmate1/components/healthjournal/mood.dart';
//import 'package:healthmate1/components/healthjournal/SharedPreferencesService.dart';
import 'package:healthmate1/components/healthjournal/moodwidget.dart';
import 'package:table_calendar/table_calendar.dart';


class HealthJournal extends StatefulWidget {
  const HealthJournal ({super.key});

  @override
  State<HealthJournal> createState() => _HealthJournalState();
}

class _HealthJournalState extends State<HealthJournal> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Journal'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2040, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: MoodWidget(selectedDate: _selectedDay),
          ),
        ],
      ),
    );
  }
}