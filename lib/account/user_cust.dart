import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCust extends StatefulWidget {
  const UserCust({super.key});

  @override
  UserCustState createState() => UserCustState();
}

class UserCustState extends State<UserCust> {
  final List<String> backgrounds = [
    'assets/blueBackground.png',
    'assets/greenBackground.png',
    'assets/pinkBackground.png',
    'assets/purpleBackground.png',
    'assets/redBackground.png',
  ];

  final List<String> heads = [
    'assets/head1.png',
    'assets/head2.png',
    'assets/head3.png',
  ];

  final List<String> hairStyles = [
    'assets/blackHair1.png',
    'assets/blondeHair1.png',
    'assets/brownHair1.png',
    'assets/redHair1.png',
    'assets/blackHair2.png',
    'assets/blondeHair2.png',
    'assets/brownHair2.png',
    'assets/redHair2.png',
    'assets/cuteHairBlack.png',
    'assets/cuteHairBlonde.png',
    'assets/cuteHairRed.png',
    'assets/pigtailsBlonde.png',
    'assets/pigtailsBrown.png',
    'assets/pigtailsRed.png',
  ];

  final List<String> expressions = [
    'assets/faceBlush.png',
    'assets/faceCute.png',
    'assets/faceElated.png',
    'assets/faceSmile.png',
    'assets/faceSmirk.png',
  ];

  int backgroundIndex = 0;
  int headIndex = 0;
  int hairIndex = 0;
  int expressionIndex = 0;

  void cycleImage(
    List<String> list,
    int direction,
    Function(int) updateIndex,
    int currentIndex,
  ) {
    setState(() {
      int newIndex =
          (direction == 1)
              ? (currentIndex + 1) % list.length
              : (currentIndex - 1 + list.length) % list.length;
      updateIndex(newIndex);
    });
  }

  Future<void> _saveSelections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('backgroundIndex', backgroundIndex);
    await prefs.setInt('headIndex', headIndex);
    await prefs.setInt('hairIndex', hairIndex);
    await prefs.setInt('expressionIndex', expressionIndex);


    if (!mounted) return;


    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Changes saved!")));
  }

  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundIndex = prefs.getInt('backgroundIndex') ?? 0;
      headIndex = prefs.getInt('headIndex') ?? 0;
      hairIndex = prefs.getInt('hairIndex') ?? 0;
      expressionIndex = prefs.getInt('expressionIndex') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSelections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd4a5c2),
      appBar: AppBar(title: const Text("Character Customization")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  backgrounds[backgroundIndex],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Image.asset(heads[headIndex], width: 150, height: 150),
                Image.asset(hairStyles[hairIndex], width: 160, height: 160),
                Image.asset(
                  expressions[expressionIndex],
                  width: 140,
                  height: 140,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                buildSelectionRow(
                  "Background",
                  backgrounds,
                  (i) => setState(() => backgroundIndex = i),
                  backgroundIndex,
                ),
                const SizedBox(height: 10),
                buildSelectionRow(
                  "Head",
                  heads,
                  (i) => setState(() => headIndex = i),
                  headIndex,
                ),
                const SizedBox(height: 10),
                buildSelectionRow(
                  "Hair",
                  hairStyles,
                  (i) => setState(() => hairIndex = i),
                  hairIndex,
                ),
                const SizedBox(height: 10),
                buildSelectionRow(
                  "Expression",
                  expressions,
                  (i) => setState(() => expressionIndex = i),
                  expressionIndex,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveSelections,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  Widget buildSelectionRow(
    String title,
    List<String> list,
    Function(int) updateIndex,
    int currentIndex,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 30),
          onPressed: () => cycleImage(list, -1, updateIndex, currentIndex),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 30),
          onPressed: () => cycleImage(list, 1, updateIndex, currentIndex),
        ),
      ],
    );
  }
}
