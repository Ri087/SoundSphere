import 'package:flutter/material.dart';

import '../models/music.dart';

class MusicQueueWidget {
  final Music music;
  MusicQueueWidget({required this.music});


  Widget getWidget(context) {
    Widget cover = const Icon(Icons.music_note);

    if (music.cover != null) {
      cover = Image.network(music.cover!);
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
              decoration: const BoxDecoration(color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(7.0))),
              child: cover,
            ),
          ),
          Text(music.title!)
        ],
      ),
    );
  }
}