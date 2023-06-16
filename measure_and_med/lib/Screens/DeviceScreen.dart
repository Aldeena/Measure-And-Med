import 'package:flutter/material.dart';
import 'package:measure_and_med/Screens/NewMeasurementScreen.dart';

import 'package:measure_and_med/Screens/SetOrShowAlarmScreen.dart';

class DeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Measure & Med - Device'),
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
                    builder: (context) => NewMeasurementScreen(),
                  ),
                );
              },
              child: Text('New Measurement'),
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
              child: Text('Alarms'),
            ),
          ],
        ),
      ),
    );
  }
}
