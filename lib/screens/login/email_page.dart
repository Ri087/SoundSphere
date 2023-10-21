import 'package:SoundSphere/widgets/app_button_widget.dart';
import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../widgets/toast.dart';
import 'login_page.dart';
import 'register_page.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmail();
}

class _LoginEmail extends State<LoginEmail> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  Color buttonColor = const Color(0xFF0EE6F1);
  bool clicked = false;

  void navigate(context, dynamic isEmailInDB,) {
    Navigator.push(context, MaterialPageRoute(builder:
        (context) => isEmailInDB ? LoginPassword(
          emailController: _controllerEmail,
          passwordController: _controllerPassword,
        ) : RegisterPassword(
          emailController: _controllerEmail,
          passwordController: _controllerPassword,
          confirmPasswordController: _controllerConfirmPassword,)
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
                      controller: _controllerEmail,
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
                  child: AppButtonWidget(
                    buttonText: "NEXT",
                    buttonIcon: const Icon(Icons.arrow_forward_outlined, color: Colors.white,),
                    onPressed: () {
                      if (_controllerEmail.text.replaceAll(" ", "") == "") {
                        ToastUtil.showErrorToast(context, "Error: Please enter a valid email");
                      } else {
                        String email = _controllerEmail.text.toLowerCase().trim();
                        AppUser.userExist(email).then((value) {
                          _controllerEmail.text = email;
                          navigate(context, value);
                        }).onError((error, stackTrace) {ToastUtil.showErrorToast(context, "Error: Connection error");});
                      }
                    }
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
