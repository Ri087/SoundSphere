

import 'package:flutter/material.dart';

import '../models/music.dart';

class MusicQueueWidget extends StatefulWidget {
  late final Music music;
  MusicQueueWidget({super.key, required this.music});
  @override
  State<StatefulWidget> createState() => _MusicQueueWidget();
}

class _MusicQueueWidget extends State<MusicQueueWidget>{
  late final Music music;
  @override
  void initState() {
    super.initState();
    music = widget.music;
  }

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left:12, right:12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 70, width: 70,
                decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child: Image.network(music!.cover!)),
            Padding(
              padding: const EdgeInsets.only(left:12),
              child: SizedBox(
                width: 200, // TODO : Valeur à changer
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(alignment: Alignment.centerLeft, child: Text(music.title, style: const TextStyle(fontSize: 22), textAlign: TextAlign.left, maxLines: 1)),
                      Container(alignment: Alignment.centerLeft,child: Text(music.artists!.join(", "), style: const TextStyle(fontSize: 16), textAlign: TextAlign.left, maxLines: 1),),
                    ],
                  ),
              ),
            ),
          ],
        ),
      );
  }
}