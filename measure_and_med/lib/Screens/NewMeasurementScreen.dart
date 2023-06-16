import 'package:flutter/material.dart';
import 'dart:io';

class NewMeasurementScreen extends StatefulWidget {
  const NewMeasurementScreen({Key? key}) : super(key: key);

  @override
  _NewMeasurementScreenState createState() => _NewMeasurementScreenState();
}

class _NewMeasurementScreenState extends State<NewMeasurementScreen> {
  void _sendCommand(String command) {
    final ipAddress = '192.168.18.19';
    final port = 80;

    Socket.connect(ipAddress, port).then((socket) {
      socket.write(command);
      socket.flush();

      socket.close();
      print('Command sent successfully');
    }).catchError((e) {
      print('Error sending command: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Measure & Med - New Measurement'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200], // Set the background color to light gray
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Press for a new measurement',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _sendCommand('Temperatura'),
                child: Text('Temperature'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _sendCommand('MAX30100'),
                child: Text('Heart Rate/ Saturation of Oxygen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
