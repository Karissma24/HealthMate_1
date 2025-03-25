import 'package:flutter/material.dart';
import 'package:healthmate1/components/healthjournal/SharedPreferencesService.dart';
import 'mood.dart';

class MoodWidget extends StatefulWidget {
  final DateTime selectedDate;
  const MoodWidget({super.key, required this.selectedDate});

  @override
  State<MoodWidget> createState() => _MoodWidgetState();
}

class _MoodWidgetState extends State<MoodWidget> {
  String _selectedMoodImage = '';

  @override
  void initState() {
    super.initState();
    _loadMood();
  }
Future<void> _loadMood() async {
    String dateKey = 'mood_${widget.selectedDate.toString()}';
    String moodImage = SharedPreferencesService.getString(dateKey);
    setState(() {
      _selectedMoodImage = moodImage;
    });
  }

  Future<void> _saveMood(String moodImagePath) async {
    String dateKey = 'mood_${widget.selectedDate.toString().split(' ')[0]}';
    await SharedPreferencesService.setString(dateKey, moodImagePath);
    setState(() {
      _selectedMoodImage = moodImagePath;
    });
  }

  @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  int numberOfColumns = 3; // Adjust this to fit your design
  double imageWidth = (screenWidth / numberOfColumns) - 10;
  double imageHeight = imageWidth;

  return Scaffold(
    appBar: AppBar(
      leading: Container(), // Explicitly set an empty container to remove the back button
      centerTitle: true, // Optional: Center the title if desired
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically in the column
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "How are you feeling today?", // Your header text
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Styling for the text
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              bool isSelected = moods[index].imageAsset == _selectedMoodImage;
              return GestureDetector(
                onTap: () => _saveMood(moods[index].imageAsset),
                child: Container(
                  decoration: isSelected ? BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 173, 143, 255), width: 2),
                    borderRadius: BorderRadius.circular(9)
                  ) : null,
                  child: Image.asset(
                    moods[index].imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}