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
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _medicineController =
      TextEditingController(); // New controller for medicine field
  int _selectedFrequency = 0;
  int _selectedStorage = 0;

  void _sendDataToDevice() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email != null) {
      final selectedFrequency = _selectedFrequency + 1;
      final alarmsCollection = FirebaseFirestore.instance.collection('alarms');

      final int hours = int.tryParse(_hoursController.text) ?? 0;
      final int minutes = int.tryParse(_minutesController.text) ?? 0;

      for (int i = 0; i < selectedFrequency; i++) {
        final newAlarm = Alarm(
          hours: hours,
          minutes: minutes,
          frequency: selectedFrequency,
        );

        newAlarm.setNextAlarmTimes();
        final alarmTime = newAlarm.nextAlarmTimes[i];

        final formattedHour = alarmTime.hour.toString().padLeft(2, '0');
        final formattedMinute = alarmTime.minute.toString().padLeft(2, '0');

        await alarmsCollection.add({
          'hours': formattedHour,
          'minutes': formattedMinute,
          'frequency': newAlarm.frequency,
          'storage': _selectedStorage + 1,
          'medicine':
              _medicineController.text, // Save the value of medicine field
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
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _medicineController.dispose(); // Dispose the medicine field controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure & Med - Set Alarm'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Set Alarm : 24 hour format (HH:MM)'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // New row for medicine field
                Text('Medicine: '),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _medicineController,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hours: '),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Minutes: '),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
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
            Text('Storage:'),
            ToggleButtons(
              children: [
                Text('Storage 1'),
                Text('Storage 2'),
                Text('Storage 3'),
              ],
              isSelected: List.generate(
                3,
                (index) => _selectedStorage == index,
              ),
              onPressed: (index) {
                setState(() {
                  _selectedStorage = index;
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
