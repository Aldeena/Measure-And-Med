import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:measure_and_med/Screens/DeviceScreen.dart';
import 'package:measure_and_med/Screens/MeasurementScreen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Center(child: Text('Measure & Med - Home Page')),
          centerTitle: true,
          actions: [
            IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
          ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("User connected as: " + user.email!),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeviceScreen()),
                );
              },
              child: Text("Device"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeasurementScreen()),
                );
              },
              child: Text("Measurements"),
            )
          ],
        ),
      ),
    );
  }
}
