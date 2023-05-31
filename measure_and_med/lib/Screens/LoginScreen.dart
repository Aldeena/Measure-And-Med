import 'package:flutter/material.dart';
import 'package:measure_and_med/Components/my_Button.dart';
import 'package:measure_and_med/Components/my_TextField.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //text Editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Column(children: [
              const SizedBox(height: 50),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              //Seja bem-vindo

              Text('Seja bem-vindo!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  )),

              const SizedBox(height: 50),

              //username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
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
                      'Esqueceu a Senha?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              //sign in button
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 10),

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
        ));
  }
}
