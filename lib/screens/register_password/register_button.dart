import 'package:SoundSphere/screens/home.dart';
import 'package:SoundSphere/screens/login_password/login_password.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPassword()));
      },
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith(
            (states) => const Size(350, 50)),
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("REGISTER", style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(Icons.login, color: Colors.white,),
          )
        ],
      ),
    );
  }
}
