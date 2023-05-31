import 'package:flutter/material.dart';
import 'package:measure_and_med/Screens/LoginScreen.dart';
import 'package:measure_and_med/Screens/RegisterScreen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  //Mostrar a página de login
  bool showLoginScreen = true;

  //Troca entre tela de login e tela de registro
  void toogleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onTap: toogleScreens);
    } else {
      return RegisterScreen(onTap: toogleScreens);
    }
  }
}
