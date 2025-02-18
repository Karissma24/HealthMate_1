import 'package:flutter/material.dart';


class homepage extends StatelessWidget {
    const homepage({super.key});
  
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 230, 216, 253),
          appBar: AppBar(
            title:Text('HealthMatea'),
            backgroundColor: Colors.white,
            elevation: 10,
            ),
          drawer:Drawer(
            backgroundColor: const Color.fromARGB(255, 208, 190, 241),
            child: Column(
              children: [
                DrawerHeader(
                  child: Icon(
                    Icons.favorite,
                    size: 48,
                  ),
                ),

                //Homepage 
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home Page"),
                  onTap: (){
                    // pop drawer first
                    Navigator.pop(context);
                    // go to HomePage
                    Navigator.pushNamed(context, '/HomePage');
                  },
                ),
              
                //Healthbot
                ListTile(
                  leading: Icon(Icons.insert_comment_rounded),
                  title: Text("Health Bot"),
                  onTap: (){
                    //pop draw frist 
                    Navigator.pop(context);
                    // go to Healthbot
                    Navigator.pushNamed(context, '/Healthbot');
                  },

                  ),

                // Health Journal
                ListTile(
                  leading: Icon(Icons.feed),
                  title: Text("Health Journal"),
                  onTap: (){
                    //pop draw frist 
                    Navigator.pop(context);
                    // go to HealthJournal
                    Navigator.pushNamed(context, '/HealthJournal');
                  },

                  ),

                //Health
                ListTile(
                  leading: Icon(Icons.monitor_heart_rounded),
                  title: Text("My Health"),
                  onTap: (){
                    //pop draw first 
                    Navigator.pop(context);
                    // go to Health
                    Navigator.pushNamed(context, '/MyHealth');
                  },

                  ),

                //Hospitals 
                ListTile(
                  leading: Icon(Icons.local_hospital_rounded),
                  title: Text("Hospitals"),
                  onTap: (){
                    //pop draw first 
                    Navigator.pop(context);
                    // go to Hospitals
                    Navigator.pushNamed(context, '/Hospitals');
                  },

                  ),

                //settings
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: (){
                    //pop draw first 
                    Navigator.pop(context);
                    // go to Settings
                    Navigator.pushNamed(context, '/Settings'); //making a change 
                  },

                  ),
              ],
            ),
          ) ,
        );

    }
}