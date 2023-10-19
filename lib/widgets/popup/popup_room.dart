import 'package:SoundSphere/screens/room_users.dart';
import 'package:SoundSphere/screens/settings.dart';
import 'package:SoundSphere/widgets/popup/popup_warning_delete_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/room.dart';
import '../toast.dart';


class PopupRoom extends StatelessWidget {
  final Room room;
  const PopupRoom({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    Future openPopupDeleteRoom() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PopupWarningDeleteRoom(warningText: "You are going to delete the sphere. Are you sure ?", fromPopup: true);
        }
    );

    return AlertDialog(
      elevation: 10,
      alignment: Alignment.center,
      content: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (room.members[FirebaseAuth.instance.currentUser!.uid]["room"]["settings"]) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(room: room)));
                          } else {
                            ToastUtil.showErrorToast(context, "Not permitted");
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0EE6F1)), borderRadius: BorderRadius.circular(7)),
                          child: const Icon(Icons.settings, color: Color(0xFF0EE6F1), size: 40,),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top : 15),
                      child: Text('SETTINGS', textDirection: TextDirection.ltr, style: TextStyle(color: Color(0xFF0EE6F1),fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (room.members[FirebaseAuth.instance.currentUser!.uid]["room"]["delete_room"]) {
                            openPopupDeleteRoom();
                          } else {
                            ToastUtil.showErrorToast(context, "Not permitted");
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFFF86C9)),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: const Icon(Icons.delete, color: Color(0xFFFF86C9), size: 40,),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text("DELETE", style: TextStyle(color: Color(0xFFFF86C9), fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,)
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (room.members[FirebaseAuth.instance.currentUser!.uid]["room"]["users"]) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RoomUsersPage(room: room)));
                          } else {
                            ToastUtil.showErrorToast(context, "Not permitted");
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFFE681)), borderRadius: BorderRadius.circular(7)),
                          child: const Icon(Icons.group, color: Color(0xFFFFE681), size: 40,),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top : 15),
                      child: Text('USERS', textDirection: TextDirection.ltr, style: TextStyle(color: Color(0xFFFFE681),fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (room.members[FirebaseAuth.instance.currentUser!.uid]["room"]["chat"]) {
                          } else {
                            ToastUtil.showErrorToast(context, "Not permitted");
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: const Icon(Icons.chat_bubble, color: Colors.white, size: 40,),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text("SOON", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}