import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

class BluetoothModel extends Model {
  BluetoothConnection? _connection;

  BluetoothConnection? get connection => _connection;

  void setConnection(BluetoothConnection connection) {
    _connection = connection;
    notifyListeners();
  }
}

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final BluetoothModel _bluetoothModel = BluetoothModel();
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
  }

  void _getBluetoothDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _devicesList = devices;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      _bluetoothModel.setConnection(connection);
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measure & Med - Alarmes'),
        centerTitle: true,
      ),
      body: ScopedModel<BluetoothModel>(
        model: _bluetoothModel,
        child: ListView.builder(
          itemCount: _devicesList.length,
          itemBuilder: (context, index) {
            BluetoothDevice device = _devicesList[index];
            return ListTile(
              title: Text(device.name ?? 'Unknown Device'),
              subtitle: Text(device.address),
              onTap: () {
                setState(() {
                  _selectedDevice = device;
                });
                _connectToDevice(device);
              },
              selected: device == _selectedDevice,
            );
          },
        ),
      ),
    );
  }
}
