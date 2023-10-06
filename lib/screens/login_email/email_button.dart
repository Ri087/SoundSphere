import 'package:SoundSphere/models/user.dart';
import 'package:SoundSphere/screens/login_password/login_password.dart';
import 'package:SoundSphere/screens/register_password/register_password.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  // ignore: non_constant_identifier_names
  void Navigate(BuildContext context, bool isOk, TextEditingController email,
      TextEditingController password, TextEditingController confirmPassword) {
    if (isOk) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPassword(
                    emailController: email,
                    passwordController: password,
                  )));
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPassword(
                  controllerEmail: email,
                  passwordController: password,
                  confirmPasswordController: confirmPassword,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
      child: ElevatedButton(
        onPressed: () async {
          try {
            final bool isOk =
                await User.userExist(emailController.text.toLowerCase());
            print(isOk);
            // ignore: use_build_context_synchronously
            Navigate(context, isOk, emailController, passwordController,
                confirmPasswordController);
          } catch (e) {
            print(e);
          }
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
            Text(
              "NEXT",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
