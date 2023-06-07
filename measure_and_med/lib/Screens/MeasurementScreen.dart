import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      final collectionRef = FirebaseFirestore.instance.collection('vitals');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }

      final firstName = userDoc.data()!['firstName'] as String? ?? '';
      final lastName = userDoc.data()!['lastName'] as String? ?? '';

      // Check if a document with the same createdAt value already exists
      final querySnapshot = await collectionRef
          .where('createdAt', isEqualTo: entry.createdAt)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        print('Vitals already exist for this createdAt: ${entry.createdAt}');
        return;
      }

      final measurement = Measurement(
        createdAt: entry.createdAt,
        temperature: entry.field1,
        firstName: firstName,
        lastName: lastName,
      );

      await collectionRef.add(measurement.toJson());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Measure & Med - Medições'),
        centerTitle: true,
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
                        Text('Temperatura(ºC): ${entry.field1}'),
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

  Entry({
    required this.createdAt,
    required this.entryId,
    required this.field1,
  });
}

class Measurement {
  final String createdAt;
  final String temperature;
  final String firstName;
  final String lastName;

  Measurement({
    required this.createdAt,
    required this.temperature,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'temperature': temperature,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
