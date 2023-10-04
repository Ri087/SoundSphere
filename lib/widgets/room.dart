import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomWidget {

  const RoomWidget({required this.room});
  final Room room;

  Future<void> navigateToRoom(context) async {
    /*Navigator.push(context, MaterialPageRoute(
        builder: (context) =>);*/
  }

  Widget getWidget(context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF262525), borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 8, right: 8, top: 36, bottom: 36),
            decoration: const BoxDecoration(border: Border(right: BorderSide(style: BorderStyle.solid, color: Colors.white24, width: 1))),
            child: const Icon(Icons.file_open_rounded, color: Colors.white),
          ),
          Material(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {navigateToRoom(context);},
              child: Container(
                decoration: const BoxDecoration(border: Border(right: BorderSide(style: BorderStyle.solid, color: Colors.white24, width: 1))),
                padding: const EdgeInsets.all(10),
                width: 251,
                height: 95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(room.title!, style: const TextStyle(color: Colors.white, fontSize: 18, overflow: TextOverflow.ellipsis),),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(room.description!, style: const TextStyle(color: Colors.white),)
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}