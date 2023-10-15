import 'package:SoundSphere/models/app_user.dart';
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
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: newUsername,
                decoration: InputDecoration(
                  hintText: 'Your new username',
                  filled: true,
                  fillColor: const Color(0xFF02203A),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0xFFFFE681))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0xFFFFE681))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          width: 2.0, color: Color(0xFFFFE681))),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser!.updateDisplayName(newUsername.text).then((value) {
                        AppUser.collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).update({"display_name": newUsername.text}).then((value) {
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

                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith(
                            (states) => const Size(350, 50)),
                    backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => const Color.fromARGB(255, 14, 230, 241)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: const BorderSide(width: 2.0),
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CONFIRM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(Icons.check, color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

}