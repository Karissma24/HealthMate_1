import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'card_data.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<CardData> cardDataList = [
    // Healio AI Bot
    CardData(
      imagePath: 'lib/images/HeailoSolo.png',
      title: 'Heailo',
      color1: const Color(0xFFf5a1c6),
      color2: Color(0xFFdc93ff),
      imageWidth: 120,
      imageHeight: 400,
      onTap: (context) => Navigator.pushNamed(context, '/HealthBot'),
    ),

    // My Health
    CardData(
      imagePath: 'lib/images/MyHealth.png',
      title: 'My Health',
      color1: const Color(0xFF6f66a3),
      color2: Color(0xFFa1cfff),
      imageWidth: 130,
      imageHeight: 400,
      onTap: (context) => Navigator.pushNamed(context, '/MyHealth'),
    ),

    // Health Journal
    CardData(
      imagePath: 'lib/images/HealthJournal.png',
      title: 'My Health Journal',
      color1: const Color(0xFF41678b),
      color2: Color(0XFF5ca2ff),
      imageWidth: 200,
      imageHeight: 200,
      onTap: (context) => Navigator.pushNamed(context, '/HealthJournal'),
    ),

    // Hospital Locations
    CardData(
      imagePath: 'lib/images/Hospital_Location.png',
      title: 'Hospitals Near Me',
      color1: const Color(0xFFffaac9),
      color2: Color(0xFFff4e4e),
      imageWidth: 227,
      imageHeight: 400,
      onTap: (context) => Navigator.pushNamed(context, '/GoogleMap'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFc5c5ff), Color(0xFFdbebff)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Welcome to Health Mate!',
                      style: GoogleFonts.fredoka(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/images/HeailoBow.png',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: cardDataList.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 25),
                itemBuilder:
                    (context, index) => buildCard(context, cardDataList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, CardData data) => InkWell(
    onTap: () => data.onTap?.call(context),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [data.color1, data.color2],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  data.imagePath,
                  width: data.imageWidth,
                  height: data.imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                data.title,
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

