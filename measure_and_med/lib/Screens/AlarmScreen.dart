import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WifiModel extends Model {
  Socket? _socket;

  Socket? get socket => _socket;

  void setSocket(Socket socket) {
    _socket = socket;
    notifyListeners();
  }
}

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final WifiModel _wifiModel = WifiModel();
  String _ipAddress = '192.168.1.100'; // Replace with your ESP32's IP address

  void _connectToESP32() async {
    try {
      Socket socket = await Socket.connect(_ipAddress, 80);
      _wifiModel.setSocket(socket);
    } catch (e) {
      print('Error connecting to ESP32: $e');
    }
  }

  void _sendDataToESP32() async {
    try {
      final socket = _wifiModel.socket;
      if (socket != null) {
        String data = 'Test data';
        socket.write(data);
      }
    } catch (e) {
      print('Error sending data to ESP32: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measure & Med - Alarmes'),
        centerTitle: true,
      ),
      body: ScopedModel<WifiModel>(
        model: _wifiModel,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ESP32 Connection Status'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _connectToESP32,
                child: Text('Connect to ESP32'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendDataToESP32,
        child: Icon(Icons.send),
      ),
    );
  }
}
