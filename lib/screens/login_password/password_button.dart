import 'package:SoundSphere/screens/home.dart';
import 'package:SoundSphere/screens/login_email/login_email.dart';
import 'package:SoundSphere/screens/login_password/login_password.dart';
import 'package:flutter/material.dart';

class PasswordButton extends StatelessWidget {
  const PasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Home()));
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.resolveWith(
              (states) => const Size(350, 50)),
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => const Color.fromARGB(255, 14, 230, 241)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(width: 2.0),
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("LOGIN", style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(Icons.login, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }
}
