import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../widgets/toast.dart';
import 'login_page.dart';
import 'register_page.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmail();
}

class _LoginEmail extends State<LoginEmail> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword = TextEditingController();

  void navigate(context, bool isOk,) {
    Navigator.push(context, MaterialPageRoute(builder:
        (context) => isOk ? LoginPassword(
          emailController: controllerEmail,
          passwordController: controllerPassword,
        ) : RegisterPassword(
          controllerEmail: controllerEmail,
          passwordController: controllerPassword,
          confirmPasswordController: controllerConfirmPassword,)
    ));
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
                child: Image.asset('assets/images/image_transparent_fit.png', height: 144, width: 144,),
              ),
              const Text('SoundSphere', style: TextStyle(fontSize: 32, fontFamily: "ZenDots"),),
            ],
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 15),
                child: Text('Hello! Type your email to login!', style: TextStyle(fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    controller: controllerEmail,
                    decoration: InputDecoration(
                        hintText: "Email",
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
                    if (controllerEmail.text == "") {
                      ToastUtil.showErrorToast(context, "Error: Please enter a valid email");
                      return;
                    }
                    try {
                      User.userExist(controllerEmail.text.toLowerCase().replaceAll(" ", "")).then((value) {
                        controllerEmail.text = controllerEmail.text.toLowerCase().replaceAll(" ", "");
                        navigate(context, value);
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith((states) => const Size(350, 55)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => const Color.fromARGB(255, 14, 230, 241)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7), side: const BorderSide(width: 2.0, color: Color.fromARGB(255, 14, 230, 241)))),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("NEXT",style:TextStyle(fontWeight: FontWeight.bold),),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_forward),
                      )
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
