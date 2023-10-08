import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../widgets/toast.dart';
import '../home.dart';

class RegisterPassword extends StatelessWidget {
  const RegisterPassword({Key? key, required this.controllerEmail, required this.passwordController, required this.confirmPasswordController}) : super(key: key);
  final TextEditingController controllerEmail;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

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
                padding: EdgeInsets.only(top: 20, bottom: 15),
                child: Text('Type a password to join us !', style: TextStyle(fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      TextField(
                        controller: passwordController,
                        obscureText: true,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Confirm your password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    if (passwordController.value == confirmPasswordController.value) {
                      User().register(controllerEmail.text, passwordController.text);
                      ToastUtil.showSuccesToast(context, "Success: Account created !");
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Home()));
                    } else {
                      ToastUtil.showErrorToast(context, "Error: Passwords don't match !");
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
                      Text("REGISTER", style: TextStyle(fontWeight: FontWeight.bold),),
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
