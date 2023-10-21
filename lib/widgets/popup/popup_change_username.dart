import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/widgets/app_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../toast.dart';

class PopupChangeUsername extends StatelessWidget {
  PopupChangeUsername({super.key});
  final TextEditingController newUsername = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      title: const Text('Change your username', style: TextStyle(color: Color(0xFFFFE681)), textAlign: TextAlign.center,),
      content: SizedBox(
          height: 160,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: newUsername,
                  decoration: InputDecoration(
                    hintText: 'Your new username',
                    filled: true,
                    fillColor: const Color(0xFF02203A),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButtonWidget(
                    buttonText: "CONFIRM",
                    buttonIcon: const Icon(Icons.check, color: Colors.white,),
                    onPressed: () {
                      if (newUsername.text.isEmpty || newUsername.text.trim() == FirebaseAuth.instance.currentUser!.displayName) {
                        ToastUtil.showShortErrorToast(context, "New username invalid");
                        return;
                      }
                      try {
                        FirebaseAuth.instance.currentUser!.updateDisplayName(newUsername.text.trim()).whenComplete(() {
                          AppUser.collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).update({"display_name": newUsername.text.trim()}).whenComplete(() {
                            ToastUtil.showSuccessToast(context, "Success: Username has been updated");
                            newUsername.clear();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        });
                      } catch (_) {
                        ToastUtil.showErrorToast(context, "Error: An error has occurred");
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

}