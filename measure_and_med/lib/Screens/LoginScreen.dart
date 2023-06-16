import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:measure_and_med/Components/my_Button.dart';
import 'package:measure_and_med/Components/my_TextField.dart';
// ignore: unused_import
import 'package:measure_and_med/Components/SquareTile.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text Editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    //Circulo de carregamento aparece
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //Logando usuario
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //Removendo circulo de carregamento
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //Removendo circulo de carregamento
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.greenAccent,
          title: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 40),

                //logo
                const Icon(
                  Icons.lock,
                  size: 50,
                ),

                const SizedBox(height: 40),

                //Seja bem-vindo

                Text('Welcome!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),

                const SizedBox(height: 10),

                //username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //password textfield

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //sign in button
                MyButton(
                  text: "Login now",
                  onTap: signUserIn,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     // google button
                //     SquareTile(imagePath: 'lib/images/Logo Measure and Med.jpeg'),
                //   ],
                // ),

                // //ou continuar com
                // Row(
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         thickness: 0.5,
                //         color: Colors.grey[400],
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //       child: Text('Ou continuar com',
                //           style: TextStyle(color: Colors.grey[700])),
                //     ),
                //     Expanded(
                //       child: Divider(
                //         thickness: 0.5,
                //         color: Colors.grey[400],
                //       ),
                //     )
                //   ],
                // )

                // //google sign in buttons

                // //Sem cadastro? Registre-se agora
              ]),
            ),
          ),
        ));
  }
}
