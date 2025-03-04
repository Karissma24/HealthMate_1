import 'package:flutter/material.dart';

class HealthJournal extends StatelessWidget {
    const HealthJournal({super.key});
  
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                   'lib/images/HeailoPencil.png',
                  height: 70,
                ),
                SizedBox(width: 10),
                Text('Health Journal')
              ]
              
            )
          ),
        );

    }

}