import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ShowAlarmScreen extends StatefulWidget {
  @override
  _ShowAlarmScreenState createState() => _ShowAlarmScreenState();
}

class _ShowAlarmScreenState extends State<ShowAlarmScreen> {
  List<Map<String, dynamic>>? alarms;

  @override
  void initState() {
    super.initState();
    fetchAlarms();
  }

  Future<void> fetchAlarms() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('alarms')
          .where('email', isEqualTo: email)
          .get();

      final fetchedAlarms = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'docId': doc.id, // Add the document ID
          'hours': data['hours'],
          'minutes': data['minutes'],
          'frequency': data['frequency'],
          'storage': data['storage'],
        };
      }).toList();

      setState(() {
        alarms = fetchedAlarms;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Show Alarms'),
          backgroundColor: Colors.greenAccent,
        ),
        body: alarms != null
            ? alarms!.isNotEmpty
                ? ListView.builder(
                    itemCount: alarms!.length,
                    itemBuilder: (context, index) {
                      final alarm = alarms![index];
                      return ListTile(
                        title:
                            Text('Time: ${alarm['hours']}:${alarm['minutes']}'),
                        subtitle:
                            Text('Frequency: ${alarm['frequency']}x a day'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteAlarm(
                                alarm['docId']); // Pass the document ID
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('No alarms found'),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (alarms != null) {
              _sendAlarmsToServer(alarms!);
            }
          },
          child: Icon(Icons.send),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Show Alarms'),
          backgroundColor: Colors.greenAccent,
        ),
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }
  }

  Future<void> _deleteAlarm(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('alarms').doc(docId).delete();
      setState(() {
        alarms?.removeWhere((alarm) => alarm['docId'] == docId);
      });
      print('Alarm deleted successfully');
    } catch (e) {
      print('Error deleting alarm: $e');
    }
  }

  void _sendAlarmsToServer(List<Map<String, dynamic>> alarms) {
    final ipAddress = '192.168.18.19';
    final port = 80;

    Socket.connect(ipAddress, port).then((socket) {
      final jsonAlarms = alarms.map((alarm) => alarm.toString()).toList();
      final alarmsData = jsonAlarms.join('\n');

      socket.write(alarmsData);
      socket.flush();

      socket.close();
      print('Alarms sent successfully');
    }).catchError((e) {
      print('Error sending alarms: $e');
    });
  }
}
