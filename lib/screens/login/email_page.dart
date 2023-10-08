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
  late final String buttonText;
  late final Icon buttonIcon;
  late final bool Function() onPressed;
  late List<Widget> rowChildren;
  Color buttonColor = const Color(0xFF0EE6F1);
  bool clicked = false;

  void navigate(context, dynamic isEmailInDB,) {
    if (isEmailInDB == 'error') {
      ToastUtil.showErrorToast(context, "Error: Connection error");
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder:
        (context) => isEmailInDB ? LoginPassword(
          emailController: controllerEmail,
          passwordController: controllerPassword,
        ) : RegisterPassword(
          emailController: controllerEmail,
          passwordController: controllerPassword,
          confirmPasswordController: controllerConfirmPassword,)
    ));
  }

  @override
  void initState() {
    buttonText = "NEXT";
    buttonIcon = const Icon(Icons.arrow_forward_outlined);
    rowChildren = [
      Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold),),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: buttonIcon,
      )
    ];
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
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.resolveWith((states) => const Size(350, 55)),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => buttonColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7), side: BorderSide(width: 2.0, color: buttonColor))),
                    ),
                    onPressed: () {
                      setState(() {
                        if (clicked) {
                          return;
                        }
                        clicked = true;
                        buttonColor = Colors.blueGrey;
                        rowChildren = [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        ];
                      });
                      if (controllerEmail.text.replaceAll(" ", "") == "") {
                        ToastUtil.showErrorToast(context, "Error: Please enter a valid email");
                      }
                      User.userExist(controllerEmail.text.toLowerCase().replaceAll(" ", "")).then((value) {
                        controllerEmail.text = controllerEmail.text.toLowerCase().replaceAll(" ", "");
                        navigate(context, value);
                      }).onError((error, stackTrace) {ToastUtil.showErrorToast(context, "Error: Connection error");});
                      setState(() {
                        buttonColor = const Color(0xFF0EE6F1);
                        clicked = false;
                        rowChildren = [
                          Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold),),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: buttonIcon,
                          )
                        ];
                      });

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rowChildren,
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
