import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/room.dart';
import '../../screens/room.dart';
import '../toast.dart';

class PopupCreateSphere extends StatefulWidget {
  const PopupCreateSphere({super.key});

  @override
  State<StatefulWidget> createState() => _PopupCreateSphere();
}

class _PopupCreateSphere extends State<PopupCreateSphere> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  bool stateSwitch = false;
  int countMaxMembers = 5;

  @override
  Widget build(BuildContext context) {

    Future<void> navigateToRoom(Room room) async {
      final bool hasJoined = await room.addMember(FirebaseAuth.instance.currentUser!.uid);
      if (hasJoined && mounted) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => RoomPage(room: room,)));
      } else if (mounted) {
        ToastUtil.showErrorToast(context, "Error: Connection error");
      }
    }

    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      elevation: 5,
      title: const Center(child: Text("Create a Sphere", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "ZenDots", height: 0,),)),
      content: SizedBox(
        height: 380,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: controllerDescription,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Description',
                  contentPadding: const EdgeInsets.all(15),
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
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Text(countMaxMembers.toString(), style: const TextStyle(color: Colors.white),),
                IconButton(
                  onPressed: () {
                    setState(() {
                      countMaxMembers++;
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: () async {
                  final Room room = await Room.createSphere(controllerTitle.text, controllerDescription.text, stateSwitch, countMaxMembers);
                  navigateToRoom(room);
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
                    Text("CREATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.add, color: Colors.white, size: 25,),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
