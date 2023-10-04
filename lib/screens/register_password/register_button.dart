import 'package:SoundSphere/screens/login_email/login_email.dart';
import 'package:SoundSphere/screens/login_password/login_password.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginEmail()));
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(365, 50)),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 14, 230, 241)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      7), // Ajustez la valeur pour le rayon de bord
                  side: const BorderSide(
                      width:
                          2.0), // Ajustez la couleur et la largeur pour les bordures
                ),
              ),
            ),
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
