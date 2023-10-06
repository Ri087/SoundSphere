// ignore_for_file: library_private_types_in_public_api

import 'package:SoundSphere/screens/login_email/email_button.dart';
import 'package:SoundSphere/screens/login_email/email_input.dart';
import 'package:flutter/material.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  _LoginEmail createState() => _LoginEmail();
}

class _LoginEmail extends State<LoginEmail> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmePassword = TextEditingController();

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
              'Hello ! Type your email',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          LoginInput(controller: controllerEmail),
          LoginButton(
              emailController: controllerEmail,
              passwordController: controllerPassword,
              confirmPasswordController: controllerConfirmePassword),
        ],
      ),
    );
  }
}
