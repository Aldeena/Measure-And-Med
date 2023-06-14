import 'package:flutter/material.dart';
import 'package:measure_and_med/Screens/NewMeasurementScreen.dart';

import 'package:measure_and_med/Screens/SetOrShowAlarmScreen.dart';

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
                    builder: (context) => NewMeasurementScreen(),
                  ),
                );
              },
              child: Text('Nova Medição'),
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
