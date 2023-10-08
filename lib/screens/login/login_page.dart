import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/toast.dart';
import '../home.dart';
import 'email_page.dart';

class LoginPassword extends StatelessWidget {
  const LoginPassword({Key? key, required this.emailController, required this.passwordController}) : super(key: key);
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Image.asset('assets/images/image_transparent_fit.png', height: 144, width: 144,)
                ),
              ),
              const Text('SoundSphere', style: TextStyle(fontSize: 32, fontFamily: "ZenDots"),),
            ],
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 15),
                child: Text('Type your password !', style: TextStyle(fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.transparent,
                        filled: true,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.toLowerCase(), password: passwordController.text).then(
                              (value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const Home())));
                    } catch (e) {
                      ToastUtil.showErrorToast(context, "Error: Invalid password");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginEmail()));
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith((states) => const Size(350, 55)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => const Color.fromARGB(255, 14, 230, 241)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7), side: const BorderSide(width: 2.0, color: Color.fromARGB(255, 14, 230, 241)),),),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold),),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(Icons.login),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
