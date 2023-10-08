import 'package:SoundSphere/widgets/app_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/toast.dart';
import '../home.dart';
import 'email_page.dart';

class LoginPassword extends StatefulWidget {
  const LoginPassword({super.key, required this.emailController, required this.passwordController});
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<StatefulWidget> createState() => _LoginPassword();
}

class _LoginPassword extends State<LoginPassword> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool obscureText = true;

  @override
  void initState() {
    emailController = widget.emailController;
    passwordController = widget.passwordController;
    super.initState();
  }

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
                    obscureText: obscureText,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.transparent,
                      filled: true,
                      suffixIcon: Material(
                        borderRadius:const BorderRadius.horizontal(right: Radius.circular(7)),
                        color: Colors.transparent,
                        child: IconButton(
                        onPressed: () {
                          setState(() {
                            if(obscureText) {
                              obscureText = false;
                            } else {
                              obscureText = true;
                            }
                          });
                        },
                        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(255, 255, 134, 201),size: 20)),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: AppButtonWidget(
                  buttonText: "LOGIN",
                  buttonIcon: const Icon(Icons.login),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.toLowerCase(), password: passwordController.text).then(
                              (value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const Home())));
                    } catch (e) {
                      ToastUtil.showErrorToast(context, "Error: Invalid password");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginEmail()));
                    }
                    return true;
                  }
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
