import 'package:SoundSphere/screens/room.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/music.dart';
import '../models/room.dart';

class RoomWidget {

  Color genColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  RoomWidget({required this.room});
  final Room room;

  Future<void> navigateToRoom(context) async {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => RoomPage()));
  }

  Future<Widget> getMusicRow() async {
    Music? actualMusic = await Music.getActualMusic(room);

    if (actualMusic == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(color: Colors.grey),
                child: const Icon(Icons.music_note, color: Colors.white,),
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
              child: cover,
            ),
            Text(actualMusic.title!, style: const TextStyle(color: Colors.white))
          ],
        ),
      );
    }
  }

  Widget getWidget(context) {
    Future<Widget> musicRow = getMusicRow();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF02203A),
            border: Border.all(color: const Color(0xFF0EE6F1), width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(7),)
        ),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(room.title!, style: const TextStyle(color: Colors.white, fontSize: 18, ),),
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
                Text(room.members!.length.toString(), style: const TextStyle(color: Colors.white),)
              ],
            )
          ],
        ),
      ),
    );
  }
}