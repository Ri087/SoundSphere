import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/login/email_page.dart';

class PopupWarningDeleteAccount extends StatefulWidget {
  const PopupWarningDeleteAccount({super.key});

  @override
  State<StatefulWidget> createState() => _PopupWarningDeleteAccount();
}

class _PopupWarningDeleteAccount extends State<PopupWarningDeleteAccount> {
  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      title: const Text('WARNING', style: TextStyle(color: Colors.redAccent), textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("This action is irreversible! Confirm your identity to delete your account", style: TextStyle(color: Colors.white),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: obscureText,
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
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: const Color(0xFFFFE681),size: 20)),
                ),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color(0xFFFFE681), style: BorderStyle.solid,),),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color(0xFFFFE681), style: BorderStyle.solid,))
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
                TextButton(
                  onPressed: () {
                    AppUser.login(FirebaseAuth.instance.currentUser!.email!, _passwordController.text).then((value) {
                      if (value != false) {
                        _passwordController.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginEmail()));
                        AppUser.collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).delete().whenComplete(() {
                          FirebaseAuth.instance.currentUser!.delete().whenComplete(() => ToastUtil.showSuccessToast(context, "Account deleted"));
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