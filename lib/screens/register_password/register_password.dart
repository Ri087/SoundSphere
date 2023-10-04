import 'package:SoundSphere/screens/register_password/register_button.dart';
import 'package:SoundSphere/screens/register_password/register_input.dart';
import 'package:flutter/material.dart';

class RegisterPassword extends StatelessWidget {
  const RegisterPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 32, 58,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
                child: Image.asset(
              'assets/images/image_transparent.png',
              height: 280, width: 280,
            )),
          ),
          const Text(
            'SoundSphere',
            style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontFamily: "ZenDots"
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              'Type a password to join us !',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const RegisterInput(),
          const RegisterButton(),
        ],
      ),
    );
  }
}
