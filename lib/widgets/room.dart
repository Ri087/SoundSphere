import 'package:SoundSphere/screens/room.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/music.dart';
import '../models/room.dart';

class RoomWidget {
  RoomWidget({required this.room});
  final Room room;

  Color genColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  Future<void> navigateToRoom(context) async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => RoomPage(room: room,)));
  }

  Future<Widget> getMusicRow() async {
    Music? actualMusic = await Music.getActualMusic(room);

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
                child: const Icon(Icons.music_note, color: Colors.white, size:17,),
              ),
            ),
            const Text("No music", style: TextStyle(color: Colors.white),)
          ],
        ),
      );
    } else {
      Widget cover = const Icon(Icons.music_note, color: Colors.white,);

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
            Text(actualMusic.title!, style: const TextStyle(color: Colors.white))
          ],
        ),
      );
    }
  }

  Widget getWidget(context) {
    Future<Widget> musicRow = getMusicRow();
    IconData publicIcon = Icons.public;
    if (room.isPrivate!) {
      publicIcon = Icons.public_off;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigateToRoom(context),
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
                        color: genColor,
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
                          child: Text(room.title!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        FutureBuilder(
                            future: musicRow,
                            builder: (context, snapshot) {
                              Widget row;
                              if (snapshot.hasData) {
                                row = snapshot.data!;
                              } else if (snapshot.hasError) {
                                row = const Text('Error loading music');
                              } else {
                                row = const Text('Load music...');
                              }
                              return row;
                            }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(room.members!.length.toString(), style: const TextStyle(color: Colors.white),),
                            const Icon(Icons.person_rounded, color: Colors.white, size: 16),
                            const Text(" - ", style: TextStyle(color: Colors.white)),
                            Icon(publicIcon, color: Colors.white, size: 16,),
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