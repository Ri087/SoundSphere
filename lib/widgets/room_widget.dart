import 'package:SoundSphere/screens/room.dart';
import 'package:SoundSphere/utils/app_utilities.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/music.dart';
import '../models/room.dart';

class RoomWidget extends StatefulWidget {
  final Room room;
  final void Function() onReturn;
  const RoomWidget({super.key, required this.room, required this.onReturn});

  @override
  State<StatefulWidget> createState() => _RoomWidget();

}

class _RoomWidget extends State<RoomWidget> {
  late final Room _room;
  late final void Function() _onReturn;
  late Future<Widget> musicRow;

  Future<Widget> getMusicRow() async {
    Music? actualMusic = await Music.getActualMusic(_room);

    if (actualMusic == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child: const Icon(Icons.music_note, size:17,),
              ),
            ),
            const Text("No music")
          ],
        ),
      );
    } else {
      Widget cover = const Icon(Icons.music_note);

      if (actualMusic.cover != null) {
        cover = Image.network(actualMusic.cover!);
      }

      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 8.0),
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child: cover,
              ),
            ),
            Text(actualMusic.title)
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _onReturn = widget.onReturn;
    musicRow = getMusicRow();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> navigateToRoom() async {
      final bool hasJoined = await _room.addMember(FirebaseAuth.instance.currentUser!.uid);
      if (hasJoined && mounted) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => RoomPage(room: _room,))).then((value) => _onReturn());
      } else if (mounted) {
        ToastUtil.showErrorToast(context, "Error: Connection error");
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigateToRoom(),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFF02203A),
                border: Border.all(color: const Color(0xFF0EE6F1), width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(7),)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppUtilities.getRandomColor(),
                        borderRadius: const BorderRadius.all(Radius.circular(7.0)
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text(_room.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        FutureBuilder(
                            future: musicRow,
                            builder: (context, snapshot) {
                              Widget row;
                              if (snapshot.hasData) {
                                row = snapshot.data!;
                              } else {
                                row = snapshot.hasError ? const Text('Error loading music') : const Text('Load music...');
                              }
                              return row;
                            }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(_room.members.length.toString()),
                            const Icon(Icons.person_rounded, size: 16),
                            const Text(" - "),
                            Icon(_room.isPrivate ? Icons.lock : Icons.lock_open, size: 16,),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}