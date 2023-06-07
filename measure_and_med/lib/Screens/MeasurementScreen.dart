import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurement Screen'),
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
