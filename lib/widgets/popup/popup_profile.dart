import 'package:SoundSphere/widgets/popup/popup_change_username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/login/email_page.dart';

class PopupProfile extends StatelessWidget {
  const PopupProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Future openPopupChangeUsername() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupChangeUsername();
        }
    );

    return AlertDialog(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.topCenter,
      content: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0EE6F1)), borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: const Icon(Icons.person, color: Color(0xFF0EE6F1), size: 40,),
                    onPressed: () {
                      openPopupChangeUsername();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Text("Username", textDirection: TextDirection.ltr, style: TextStyle(color: Color(0xFF0EE6F1),fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFF86C9)), borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFFFF86C9), size: 40,),
                      onPressed: () {
                        try {
                          FirebaseAuth.instance.signOut().then((value) =>
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginEmail())));
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text("Log out", style: TextStyle(color: Color(0xFFFF86C9), fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),
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