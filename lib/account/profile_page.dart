import 'package:flutter/material.dart';
import 'terms_and_conditions.dart';
import 'user_cust.dart';
import 'contact_us.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  String username = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  DateTime? selectedBirthday;
  String location = '';
  double weight = 0.0;
  String height = '', waist = '', butt = '', bust = '';
  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    _loadSelections();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSelections();
  }

  Future<void> _loadSelections() async {
    if (userId == null) return;

    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        DocumentSnapshot customizationDoc =
            await _firestore.collection('customizations').doc(userId).get();

        setState(() {
          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            username = userData['username'] ?? "Guest";
            location = userData['location'] ?? '';
            weight = (userData['weight'] ?? 0.0).toDouble();
            height = userData['height'] ?? '';
            waist = userData['waist'] ?? '';
            butt = userData['butt'] ?? '';
            bust = userData['bust'] ?? '';
            if (userData['birthday'] != null) {
              selectedBirthday = DateTime.tryParse(userData['birthday']);
            }
          }

          if (customizationDoc.exists) {
            final customizationData =
                customizationDoc.data() as Map<String, dynamic>;
            backgroundIndex = customizationData['backgroundIndex'] ?? 0;
            headIndex = customizationData['headIndex'] ?? 0;
            hairIndex = customizationData['hairIndex'] ?? 0;
            expressionIndex = customizationData['expressionIndex'] ?? 0;
          }
        });
        return;
      } catch (e) {
        print("Failed to load profile data, attempt ${retryCount + 1}: $e");
        retryCount++;
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Could not load profile. Please try again later."),
      ),
    );
  }

  Future<void> _saveToFirestore() async {
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set({
      'username': username,
      'location': location,
      'weight': weight,
      'height': height,
      'waist': waist,
      'butt': butt,
      'bust': bust,
      'birthday': selectedBirthday?.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> _pickBirthday(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedBirthday = pickedDate;
      });
      await _saveToFirestore();
    }
  }

  Future<void> _pickLocation(BuildContext context) async {
    String? newLocation = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(
          text: location,
        );
        return AlertDialog(
          title: const Text('Enter Location'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Location"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (newLocation != null && newLocation.isNotEmpty) {
      setState(() {
        location = newLocation;
      });
      await _saveToFirestore();
    }
  }

  Future<void> _pickWeight(BuildContext context) async {
    TextEditingController controller = TextEditingController(
      text: weight.toString(),
    );
    String? newWeight = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Weight'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Weight in lbs"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (newWeight != null && newWeight.isNotEmpty) {
      setState(() {
        weight = double.tryParse(newWeight) ?? 0.0;
      });
      await _saveToFirestore();
    }
  }

  Future<void> _pickMeasurements(BuildContext context) async {
    TextEditingController heightController = TextEditingController(
      text: height,
    );
    TextEditingController waistController = TextEditingController(text: waist);
    TextEditingController buttController = TextEditingController(text: butt);
    TextEditingController bustController = TextEditingController(text: bust);

    String? newMeasurements = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Measurements'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    hintText: "Height in inches",
                  ),
                ),
                TextField(
                  controller: waistController,
                  decoration: const InputDecoration(
                    hintText: "Waist in inches",
                  ),
                ),
                TextField(
                  controller: buttController,
                  decoration: const InputDecoration(hintText: "Butt in inches"),
                ),
                TextField(
                  controller: bustController,
                  decoration: const InputDecoration(hintText: "Bust in inches"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'done'),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newMeasurements != null) {
      setState(() {
        height = heightController.text;
        waist = waistController.text;
        butt = buttController.text;
        bust = bustController.text;
      });
      await _saveToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd4a5c2),
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUs()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromARGB(255, 7, 76, 133),
                    width: 2,
                  ),
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
              Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 76, 133),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserCust()),
                  ).then((_) {
                    _loadSelections();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF1A85F8), width: 2),
                ),
                child: const Text("User Character Customization"),
              ),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                children: [
                  _buildPngButton(
                    imagePath: 'assets/birthday.png',
                    text: 'Birthday',
                    onPressed: () => _pickBirthday(context),
                  ),
                  _buildPngButton(
                    imagePath: 'assets/location.png',
                    text: 'Location',
                    onPressed: () => _pickLocation(context),
                  ),
                  _buildPngButton(
                    imagePath: 'assets/weight.png',
                    text: 'Weight',
                    onPressed: () => _pickWeight(context),
                  ),
                  _buildPngButton(
                    imagePath: 'assets/measurements.png',
                    text: 'Measurements',
                    onPressed: () => _pickMeasurements(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const TermsAndConditionsPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: Color(0xFF1A85F8),
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Read our privacy and AI policies!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPngButton({
    required String imagePath,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Image.asset(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 76, 133),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
