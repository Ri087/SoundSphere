import 'package:flutter/material.dart';

import '../models/music.dart';

class MusicQueueWidget extends StatelessWidget {
  final Music music;
  final void Function() onClick;
  const MusicQueueWidget({super.key, required this.music, required this.onClick});

 @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Row(
       mainAxisSize: MainAxisSize.max,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Container(
           height: 50, width: 50,
           decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
           child: Image.network(music.cover!)
         ),
         Expanded(
           child: Padding(
             padding: const EdgeInsets.only(left: 12),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 4.0),
                   child: Text(music.title, style: const TextStyle(fontSize: 20), textAlign: TextAlign.left, maxLines: 1),
                 ),
                 Text(music.artists!.join(", "), style: const TextStyle(fontSize: 16), textAlign: TextAlign.left, maxLines: 1),
               ],
             ),
           ),
         ),
         IconButton(
           onPressed: () {
             onClick();
           },
           alignment: Alignment.center,
           iconSize: 26,
           icon: const Icon(Icons.delete_outline, color: Color(0xFFFFE681)),
         ),
       ],
     ),
   );
  }
}
