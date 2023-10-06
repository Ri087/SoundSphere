import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:flutter/material.dart';

class MusicSearchWidget {
  MusicSearchWidget({required this.music, required this.room});
  final Music music;
  final Room room;

  String getArtists(List<dynamic> artists) {
    String output = "";
    for (int i = 0; i < artists.length; i++) {
      output += artists[i];
      if (artists.last != artists[i]) {
        output += ", ";
      }
    }
    return output;
  }

  Widget getWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.network(music.cover!, height: 50, width: 50,),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(music.title!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(child: Text(music.album!, style: const TextStyle(color: Colors.white), softWrap: true, overflow: TextOverflow.clip)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ToastUtil.showInfoToast(context, "Music added to the queue");
                Room.addMusic(music, room);
              },
              child: const Icon(Icons.add, color: Color(0xFF0EE6F1), size: 30,),
            ),
          )
        ],
      ),
    );
  }
}