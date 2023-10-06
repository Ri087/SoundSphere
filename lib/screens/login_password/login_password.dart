import 'package:SoundSphere/screens/login_password/password_button.dart';
import 'package:SoundSphere/screens/login_password/password_input.dart';
import 'package:flutter/material.dart';

class LoginPassword extends StatelessWidget {
  const LoginPassword(
      {Key? key,
      required this.emailController,
      required this.passwordController})
      : super(key: key);
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        2,
        32,
        58,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
                child: Image.asset(
              'assets/images/image_transparent.png',
              height: 280,
              width: 280,
            )),
          ),
          const Text(
            'SoundSphere',
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontFamily: "ZenDots"),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              'Type your password !',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          PasswordInput(passwordController: passwordController),
          PasswordButton(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
