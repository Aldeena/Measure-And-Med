// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:measure_and_med/Components/alarm.dart';

class ShowAlarmScreen extends StatelessWidget {
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('alarms')
              .where('email', isEqualTo: email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final alarms = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'docId': doc.id, // Add the document ID
                  'hours': data['hours'],
                  'minutes': data['minutes'],
                  'frequency': data['frequency'],
                };
              }).toList();

              if (alarms.isNotEmpty) {
                return ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return ListTile(
                      title:
                          Text('Time: ${alarm['hours']}:${alarm['minutes']}'),
                      subtitle: Text('Frequency: ${alarm['frequency']}x a day'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAlarm(alarm['docId']); // Pass the document ID
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('No alarms found'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
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

  void _deleteAlarm(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('alarms').doc(docId).delete();
      print('Alarm deleted successfully');
    } catch (e) {
      print('Error deleting alarm: $e');
    }
  }
}
