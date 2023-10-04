import 'package:SoundSphere/main.dart';
import 'package:SoundSphere/screens/login_email/email_button.dart';
import 'package:SoundSphere/screens/login_email/email_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginEmail extends StatelessWidget {
  const LoginEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        2,
        32,
        58,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                      child: Image.asset(
                    'assets/images/image_transparent.png',
                    height: 300,
                  )),
                ),
                const Text(
                  'SoundSphere',
                  style: TextStyle(color: Colors.white, fontSize: 42),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Hello ! Type your email',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: LoginInput(),
                ),
                const LoginButon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
