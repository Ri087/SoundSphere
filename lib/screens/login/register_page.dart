import 'package:SoundSphere/widgets/app_button_widget.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../widgets/toast.dart';
import '../home.dart';

class RegisterPassword extends StatefulWidget {
  const RegisterPassword({super.key, required this.emailController, required this.passwordController, required this.confirmPasswordController});
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  State<StatefulWidget> createState() => _RegisterPassword();

}

class _RegisterPassword extends State<RegisterPassword> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  bool obscureTextPassword = true;
  bool obscureTextConfirm = true;

  @override
  void initState() {
    emailController = widget.emailController;
    passwordController = widget.passwordController;
    confirmPasswordController = widget.confirmPasswordController;
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
                          obscureText: obscureTextPassword,
                          decoration: InputDecoration(
                            hintText: "Your password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                            suffixIcon: Material(
                              borderRadius:const BorderRadius.horizontal(right: Radius.circular(7)),
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(obscureTextPassword) {
                                      obscureTextPassword = false;
                                    } else {
                                      obscureTextPassword = true;
                                    }
                                  });
                                },
                                icon: Icon(obscureTextPassword ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(255, 255, 134, 201),size: 20)
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: obscureTextConfirm,
                            decoration: InputDecoration(
                              hintText: "Confirm your password",
                              hintStyle: const TextStyle(color: Colors.grey),
                              fillColor: Colors.transparent,
                              filled: true,
                                suffixIcon: Material(
                                  borderRadius:const BorderRadius.horizontal(right: Radius.circular(7)),
                                  color: Colors.transparent,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if(obscureTextConfirm) {
                                            obscureTextConfirm = false;
                                          } else {
                                            obscureTextConfirm = true;
                                          }
                                        });
                                      },
                                      icon: Icon(obscureTextConfirm ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(255, 255, 134, 201),size: 20)
                                  ),
                                ),
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
                  child: AppButtonWidget(
                    buttonText: "REGISTER",
                    buttonIcon: const Icon(Icons.login),
                    onPressed: () {
                      if (passwordController.value == confirmPasswordController.value) {
                        User.register(emailController.text, passwordController.text);
                        ToastUtil.showSuccessToast(context, "Success: Account created !");
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const Home()));
                      } else {
                        ToastUtil.showErrorToast(context, "Error: Passwords don't match !");
                      }
                      return true;
                  })
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
