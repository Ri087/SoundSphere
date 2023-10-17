import 'package:flutter/material.dart';

import '../models/music.dart';

class MusicQueueWidget extends StatelessWidget {
  final Music music;
  const MusicQueueWidget({super.key, required this.music});

 @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(10),
     child: Row(
       mainAxisSize: MainAxisSize.max,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Container(
           height: 50, width: 50,
           decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
           child: Image.network(music.cover!)),
         Padding(
           padding: const EdgeInsets.only(left:12),
           child: Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(music.title, style: const TextStyle(fontSize: 22), textAlign: TextAlign.left, maxLines: 1),
                 Text(music.artists!.join(", "), style: const TextStyle(fontSize: 16), textAlign: TextAlign.left, maxLines: 1),
               ],
             ),
           ),
         ),
       ],
     ),
   );
  }
}
