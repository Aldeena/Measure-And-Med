import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:measure_and_med/Components/alarm.dart';
import 'package:measure_and_med/Screens/ShowAlarmScreen.dart';

class SetAlarmScreen extends StatefulWidget {
  @override
  _SetAlarmScreenState createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedFrequency = 0;

  void _sendDataToDevice() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email != null) {
      final selectedFrequency = _selectedFrequency + 1;
      final alarmsCollection = FirebaseFirestore.instance.collection('alarms');

      for (int i = 0; i < selectedFrequency; i++) {
        final newAlarm = Alarm(
          hours: _selectedTime.hour,
          minutes: _selectedTime.minute,
          frequency: selectedFrequency,
        );

        newAlarm.setNextAlarmTimes();
        final alarmTime = newAlarm.nextAlarmTimes[i];

        await alarmsCollection.add({
          'hours': alarmTime.hour,
          'minutes': alarmTime.minute,
          'frequency': newAlarm.frequency,
          'nextAlarmTime': alarmTime.toIso8601String(),
          'email': email,
        });
      }

      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAlarmScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure & Med'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Set Alarm'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Time: '),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text(
                      _selectedTime.format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Frequency:'),
            ToggleButtons(
              children: [
                Text('1x a day'),
                Text('2x a day'),
                Text('3x a day'),
                Text('4x a day'),
              ],
              isSelected: List.generate(
                4,
                (index) => _selectedFrequency == index,
              ),
              onPressed: (index) {
                setState(() {
                  _selectedFrequency = index;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendDataToDevice,
              child: Text('Send Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
