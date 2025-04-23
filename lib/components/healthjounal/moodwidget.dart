import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../healthjournal/shared_preferences_service.dart';
import '../healthjournal/mood.dart';

class MoodWidget extends StatefulWidget {
  final DateTime selectedDate;
  const MoodWidget({super.key, required this.selectedDate});

  @override
  State<MoodWidget> createState() => _MoodWidgetState();
}

class _MoodWidgetState extends State<MoodWidget> {
  String _selectedMoodImage = '';
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? 'default';
    _loadMood();
  }

  Future<void> _loadMood() async {
    String dateKey = 'mood_${widget.selectedDate.toString().split(" ")[0]}';
    String moodImage = SharedPreferencesService.getString(dateKey, userId);
    setState(() {
      _selectedMoodImage = moodImage;
    });
  }

  Future<void> _saveMood(String moodImagePath) async {
    String dateKey = 'mood_${widget.selectedDate.toString().split(" ")[0]}';
    await SharedPreferencesService.setString(dateKey, moodImagePath, userId);
    setState(() {
      _selectedMoodImage = moodImagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int numberOfColumns = 5;
    double padding = 1;
    double spacing = 1;

    double imageSize =
        (screenWidth - (padding * 2) - (spacing * (numberOfColumns - 1))) /
        numberOfColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.only(top: 30.0, bottom: 12.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: moods.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numberOfColumns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              bool isSelected = moods[index].imagelib == _selectedMoodImage;
              return GestureDetector(
                onTap: () => _saveMood(moods[index].imagelib),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        isSelected
                            ? Border.all(
                              color: Color.fromARGB(255, 173, 143, 255),
                              width: 2,
                            )
                            : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      moods[index].imagelib,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
