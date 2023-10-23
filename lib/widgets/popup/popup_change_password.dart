import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/login/email_page.dart';

class PopupChangePassword extends StatefulWidget {
  const PopupChangePassword({super.key});

  @override
  State<StatefulWidget> createState() => _PopupChangePassword();
}

class _PopupChangePassword extends State<PopupChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      title: const Text('Change your password', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: obscurePassword,
                controller: _passwordController,
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
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(255, 255, 134, 201),size: 20)),
                    ),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: obscureNew,
              controller: _newPasswordController,
              decoration: InputDecoration(
                  hintText: "New password",
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.transparent,
                  filled: true,
                  suffixIcon: Material(
                    borderRadius:const BorderRadius.horizontal(right: Radius.circular(7)),
                    color: Colors.transparent,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureNew = !obscureNew;
                          });
                        },
                        icon: Icon(obscureNew ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(255, 255, 134, 201),size: 20)),
                  ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: obscureConfirm,
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.transparent,
                  filled: true,
                  suffixIcon: Material(
                    borderRadius:const BorderRadius.horizontal(right: Radius.circular(7)),
                    color: Colors.transparent,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirm = !obscureConfirm;
                          });
                        },
                        icon: Icon(obscureConfirm ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(255, 255, 134, 201),size: 20)),
                  ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,),),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 134, 201), style: BorderStyle.solid,))
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
                TextButton(
                  onPressed: () {
                    if (_newPasswordController.text != _confirmPasswordController.text) {
                      ToastUtil.showShortErrorToast(context, "Passwords don't match");
                      return;
                    }
                    AppUser.login(FirebaseAuth.instance.currentUser!.email!, _passwordController.text).then((value) {
                      if (value != false) {
                        FirebaseAuth.instance.currentUser!.updatePassword(_newPasswordController.text).then((value) {
                          ToastUtil.showSuccessToast(context, "Password changed");
                          _passwordController.clear();
                          _newPasswordController.clear();
                          _confirmPasswordController.clear();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginEmail()));
                        }).onError((error, stackTrace) {
                          ToastUtil.showShortErrorToast(context, "Password too weak!");
                        });
                      } else {
                        ToastUtil.showShortErrorToast(context, "Error: Invalid password");
                      }
                    });
                  },
                  child: const Text("CONFIRM"))
              ],
            ),
          )
        ],
      ),
    );
  }

}