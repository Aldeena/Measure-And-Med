import 'dart:io';
import 'package:flutter/material.dart';

class ConnectScreen extends StatefulWidget {
  final Function(Socket socket)? onConnected;

  ConnectScreen({this.onConnected});

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool _connected = false;
  bool _connecting = false;
  Socket? _socket;

  Future<void> _connectToDevice() async {
    setState(() {
      _connecting = true;
    });

    try {
      Socket socket = await Socket.connect('192.168.18.19', 80);
      setState(() {
        _connected = true;
        _socket = socket;
      });
      widget.onConnected?.call(socket);
    } catch (e) {
      print('Error connecting to device: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Connection Error'),
            content: Text('Failed to connect to the device. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _connecting = false;
      });
    }
  }

  void _disconnectFromDevice() {
    _socket?.destroy();
    setState(() {
      _connected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_connected ? 'Device Connected' : 'Device Disconnected'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _connecting
                    ? null
                    : _connected
                        ? _disconnectFromDevice
                        : _connectToDevice,
                child: _connecting
                    ? CircularProgressIndicator()
                    : _connected
                        ? Text('Disconnect')
                        : Text('Connect to Device'),
              ),
            ],
          ),
        );
      },
    );
  }
}
