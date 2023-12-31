import 'package:SoundSphere/widgets/app_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/room.dart';
import '../../screens/loading_page.dart';
import '../../screens/room.dart';
import '../toast.dart';

class PopupCreateSphere extends StatefulWidget {
  const PopupCreateSphere({super.key, required this.onReturn});
  final void Function() onReturn;

  @override
  State<StatefulWidget> createState() => _PopupCreateSphere();
}

class _PopupCreateSphere extends State<PopupCreateSphere> {
  late void Function() _onReturn;
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  late void Function() onLeave;
  bool stateSwitch = false;
  int countMaxMembers = 5;

  @override
  void initState() {
    super.initState();
    _onReturn = widget.onReturn;
  }

  @override
  Widget build(BuildContext context) {

    void navigateToRoom(Room room) {
      Future.delayed(const Duration(seconds: 1), () async {
        final bool hasJoined = await room.addMember(FirebaseAuth.instance.currentUser!.uid);
        if (hasJoined && mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoomPage(room: room,))).whenComplete(() {
            Future.delayed(const Duration(seconds: 1), () => _onReturn());
          });
        } else if (mounted) {
          Navigator.pop(context);
          ToastUtil.showErrorToast(context, "Error: Connection error");
        }
      });
    }

    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      elevation: 5,
      title: const Center(child: Text("Create a Sphere", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "ZenDots", height: 0,),)),
      content: SizedBox(
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controllerTitle,
              decoration: InputDecoration(
                hintText: 'Your Sphere name',
                filled: true,
                fillColor: const Color(0xFF02203A),
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: const BorderSide(
                        width: 2.0, color: Color(0xFFFF86C9))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: const BorderSide(
                        width: 2.0, color: Color(0xFFFF86C9))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: const BorderSide(
                        width: 2.0, color: Color(0xFFFF86C9))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15.0),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text("Visibility :", style: TextStyle(color: Colors.white, fontSize: 16),),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_open, color: Colors.white, size: 25,),
                        Switch(
                          activeColor: const Color(0xFFFF86C9),
                          value: stateSwitch,
                          onChanged: (value) {
                            setState(() {
                              stateSwitch = value;
                            });
                          }
                        ),
                        const Icon(Icons.lock, color: Colors.white, size: 25,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Max users :", style: TextStyle(color: Colors.white, fontSize: 16),),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (countMaxMembers > 1) {
                            countMaxMembers--;
                          }
                        });
                      },
                      icon: const Icon(Icons.remove, color: Colors.white)
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Text(countMaxMembers < 10 ? "0${countMaxMembers.toString()}" : countMaxMembers.toString(), style: const TextStyle(color: Colors.white),),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (countMaxMembers < 99) countMaxMembers++;
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white)
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AppButtonWidget(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoadingPage()));
                  Room.createSphere(controllerTitle.text, controllerDescription.text, stateSwitch, countMaxMembers).then((room) => navigateToRoom(room));
                },
                buttonText: 'CREATE',
                buttonIcon: const Icon(Icons.add),
              )
            ),
          ],
        ),
      ),
    );
  }
}
