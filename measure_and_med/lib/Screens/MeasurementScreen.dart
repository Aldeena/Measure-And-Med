// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GraphScreen.dart'; // Import the GraphScreen file

class MeasurementScreen extends StatefulWidget {
  MeasurementScreen({Key? key}) : super(key: key);

  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  List<Entry> entries = [];

  Future<List<Entry>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://thingspeak.com/channels/2160964/feed.json'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final feeds = jsonData['feeds'];

      List<Entry> entries = [];
      for (var feed in feeds) {
        final entry = Entry(
          createdAt: feed['created_at'],
          entryId: feed['entry_id'].toString(),
          field1: feed['field1'].toString(),
          field2: feed['field2'].toString(),
          field3: feed['field3'].toString(),
        );
        entries.add(entry);
      }

      return entries;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> updateVitalsCollection(Entry entry) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final email = user.email;

      final collectionRef = FirebaseFirestore.instance.collection('vitals');

      // Check if a document with the same createdAt value already exists
      final querySnapshot = await collectionRef
          .where('createdAt', isEqualTo: entry.createdAt)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs[0].data()['email'] == email) {
          // Overwrite existing entry with the same createdAt if email matches
          await collectionRef.doc(querySnapshot.docs[0].id).set({
            'createdAt': entry.createdAt,
            'Temperature': entry.field1,
            'BPM': entry.field2,
            'SpO2': entry.field3,
            'email': email,
          });
          print('Vitals updated successfully!');
        } else {
          print('Vitals exist for this createdAt, email does not match');
        }
        return;
      }

      final measurement = Measurement(
        createdAt: entry.createdAt,
        temperature: entry.field1,
        bpm: entry.field2,
        spo2: entry.field3,
        email: email!,
      );

      await collectionRef.add(measurement.toMap());
      print('Vitals updated successfully!');
    } catch (e) {
      print('Failed to update vitals: $e');
    }
  }

  Future<void> submitData() async {
    final entries = await fetchData();
    for (final entry in entries) {
      await updateVitalsCollection(entry);
    }
  }

  // Future<void> launchGraphScreen() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => GraphScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Measure & Med - Measurements'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.insert_chart),
          //   onPressed: launchGraphScreen,
          // ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Entry>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final entries = snapshot.data!;
              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return ListTile(
                    title: Text('Entry ID: ${entry.entryId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created At: ${entry.createdAt}'),
                        Text('Temperature(ºC): ${entry.field1}'),
                        Text('BPM: ${entry.field2}'),
                        Text('SpO2(%): ${entry.field3}'),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitData,
        child: Icon(Icons.cloud_upload),
      ),
    );
  }
}

class Entry {
  final String createdAt;
  final String entryId;
  final String field1;
  final String field2;
  final String field3;

  Entry({
    required this.createdAt,
    required this.entryId,
    required this.field1,
    required this.field2,
    required this.field3,
  });
}

class Measurement {
  final String createdAt;
  final String temperature;
  final String bpm;
  final String spo2;
  final String email;

  Measurement({
    required this.createdAt,
    required this.temperature,
    required this.bpm,
    required this.spo2,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'Temperature': temperature,
      'BPM': bpm,
      'SpO2': spo2,
      'email': email,
    };
  }
}
