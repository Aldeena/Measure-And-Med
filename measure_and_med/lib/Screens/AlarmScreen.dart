import 'package:flutter/material.dart';

import 'package:measure_and_med/Screens/SetOrShowAlarmScreen.dart';

import 'package:measure_and_med/Screens/ConnectScreen.dart';

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measure & Med - Alarmes'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectScreen(),
                  ),
                );
              },
              child: Text('Connection'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetOrShowAlarmScreen(),
                  ),
                );
              },
              child: Text('Configure Alarms'),
            ),
          ],
        ),
      ),
    );
  }
}
