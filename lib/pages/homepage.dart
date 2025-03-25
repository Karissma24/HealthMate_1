import 'package:flutter/material.dart';
import '../components/homepage/home_content.dart';
import 'package:google_fonts/google_fonts.dart';
// Import the content in my homepage

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();

}

// ignore: camel_case_types
class _HomePageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Health Mate',
          style:GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),

          ),
        backgroundColor:Color(0xFF8888e8),
        elevation: 10,
        leading: Builder(
          builder: (context)=> IconButton(
          icon: const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child:  Icon(
              Icons.menu,
              color: Colors.white,
              
            ),
          ),
          onPressed: (){
            Scaffold.of(context).openDrawer();
          },
        ),
        ),
      ),
      body: const HomeContent(),

      drawer: Drawer(
        backgroundColor: Color(0xFFc5c5ff),
        child: Column(
          children: [
            //logo 
            DrawerHeader(
              child: Image.asset(
                'lib/images/HealthMate1.png',
                 fit: BoxFit.contain,
                 height: 120,
                ),
              ),

            // Home Page

              Padding(
                padding:  const EdgeInsets.only(left: 5),
                child: ListTile(
                  leading: const Icon(Icons.home,
                  color:Colors.black,),
                  title: const Text(
                  'HomePage',
                  style: TextStyle(color: Colors.black),
                  ),
                   onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/HomePage');
                  }
                ),
              ),
            
            // Health Journal 
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                leading: const Icon(Icons.local_hospital_rounded,
                color: Colors.black,
                ),
                title: const Text(
                "Hospital's",
                style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Hospitals');
                },
              ),
            ),

            //Health Journal

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                leading: const Icon(Icons.feed,
                color: Colors.black,
                ),
                title: const Text(
                "Health Journal",
                style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/HealthJournal');
                },
              ),
            ),


            // HealthBot
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                leading: const Icon(Icons.insert_comment_rounded,
                color: Colors.black,
                ),
                title: const Text(
                "Heailo",
                style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/HealthBot');
                },
              ),
            ),

          // My Health
        

          Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                leading: const Icon(Icons.favorite_rounded,
                color: Colors.black,
                ),
                title: const Text(
                "My Health",
                style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/MyHealth');
                },
              ),
            ),

            // Settings
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                leading: const Icon(Icons.settings,
                color: Colors.black,
                ),
                title: const Text(
                "Settings",
                style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Settings');
                },
              ),
            ),
              
          ]
        ),
      ), 
    );
  }
  
}
