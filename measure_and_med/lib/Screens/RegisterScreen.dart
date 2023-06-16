// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:measure_and_med/Components/my_Button.dart';
import 'package:measure_and_med/Components/my_TextField.dart';
import 'package:measure_and_med/Components/SquareTile.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text Editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  void signUserUp() async {
    //Circulo de carregamento aparece
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //Criando usuario
    try {
      //Checando se senha e confirma senha sao iguais
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        //Adicionando detalhes do usuario
        addUserDetails(
            firstNameController.text,
            lastNameController.text,
            emailController.text,
            int.parse(ageController.text),
            int.parse(heightController.text),
            double.parse(weightController.text));
      } else {
        //Senhas nao combinam
        showErrorMessage("Different passwords!");
      }

      //Removendo circulo de carregamento
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //Removendo circulo de carregamento
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
  }

  void addUserDetails(String firstName, String lastName, String email, int age,
      int height, double weight) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
      'height': height,
      'weight': weight
    });
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

                Text('Create an account!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),

                const SizedBox(height: 10),

                //First name textfield
                MyTextField(
                  controller: firstNameController,
                  hintText: 'First name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Last name textfield
                MyTextField(
                  controller: lastNameController,
                  hintText: 'Last name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Age textfield
                MyTextField(
                  controller: ageController,
                  hintText: 'Age',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Height textfield
                MyTextField(
                  controller: heightController,
                  hintText: 'Height (cm)',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //weight textfield
                MyTextField(
                  controller: weightController,
                  hintText: 'Weight (kg)',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Email textfield
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

                //confirm password textfield

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //forgot password?
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'Esqueceu a Senha?',
                //         style: TextStyle(color: Colors.grey[600]),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(height: 10),

                //sign in button
                MyButton(
                  text: "Register",
                  onTap: signUserUp,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Connect now!',
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
