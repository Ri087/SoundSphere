import 'package:SoundSphere/screens/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/login/email_page.dart';

class PopupProfile extends StatelessWidget {
  const PopupProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.topCenter,
      content: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(7),
                    onTap: () =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserSettings())),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0EE6F1)), borderRadius: BorderRadius.circular(7)),
                      child: const Icon(Icons.person_rounded, color: Color(0xFF0EE6F1), size: 40,),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text("ACCOUNT", textDirection: TextDirection.ltr, style: TextStyle(color: Color(0xFF0EE6F1),fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        try {
                          FirebaseAuth.instance.signOut().whenComplete(() =>
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginEmail())));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFF86C9)), borderRadius: BorderRadius.circular(7)),
                        child: const Icon(Icons.logout_rounded, color: Color(0xFFFF86C9), size: 40,),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("LOGOUT", style: TextStyle(color: Color(0xFFFF86C9), fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}