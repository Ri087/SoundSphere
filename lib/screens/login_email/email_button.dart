import 'package:SoundSphere/screens/login_password/login_password.dart';
import 'package:SoundSphere/screens/register_password/register_password.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder:
              (context) => const RegisterPassword()));
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
            Text("NEXT", style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(Icons.arrow_forward, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }
}
