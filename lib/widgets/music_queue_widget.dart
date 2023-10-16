

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
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                height: 60, width: 60,
                decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child: Image.network(music!.cover!)),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(music.title, style: const TextStyle(fontSize: 22), ),
              ),
              Text(music.artists!.join(", ")),
            ],
          ),
        ],
      );
  }
}