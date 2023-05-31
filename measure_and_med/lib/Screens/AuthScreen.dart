// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:measure_and_med/Screens/LoginScreen.dart';
import 'HomeScreen.dart';
import 'LoginOrRegisterScreen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user is logged in

        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginOrRegisterScreen();
        }
      },
    ));
  }
}
