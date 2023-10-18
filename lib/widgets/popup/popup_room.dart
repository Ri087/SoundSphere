import 'package:SoundSphere/widgets/popup/popup_warning_delete_room.dart';
import 'package:flutter/material.dart';


class PopupRoom extends StatelessWidget {
  const PopupRoom({super.key});

  @override
  Widget build(BuildContext context) {
    Future openPopupDeleteRoom() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PopupWarningDeleteRoom(warningText: "You are going to remove the sphere. Are you sure ?", fromPopup: true);
        }
    );

    return AlertDialog(
      elevation: 10,
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
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0EE6F1)), borderRadius: BorderRadius.circular(7)),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFF0EE6F1), size: 40,),
                    onPressed: () {
                      // ADD CODE
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top : 25),
                  child: Text('Settings', textDirection: TextDirection.ltr, style: TextStyle(color: Color(0xFF0EE6F1),fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,),),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF86C9)),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFFF86C9), size: 40,),
                      onPressed: () => openPopupDeleteRoom(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text("Delete", style: TextStyle(color: Color(0xFFFF86C9), fontSize: 18, fontFamily: "Roboto", fontWeight: FontWeight.w400, height: 0,)
                    ),
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