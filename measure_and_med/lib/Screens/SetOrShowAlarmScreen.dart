import 'package:flutter/material.dart';
import 'package:measure_and_med/Components/alarm.dart';
import 'package:measure_and_med/Screens/SetAlarmScreen.dart';
import 'package:measure_and_med/Screens/ShowAlarmScreen.dart';

class SetOrShowAlarmScreen extends StatelessWidget {
  final List<Alarm> alarmsList = []; // Define your alarmsList here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure & Med - Alarmes'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true, // Set your desired accent color
      ),
      body: Container(
        color: Colors.white, // Set your desired background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetAlarmScreen(),
                    ),
                  );
                },
                child: Text('Set Alarm'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAlarmScreen(),
                    ),
                  );
                },
                child: Text('Show Alarms'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
