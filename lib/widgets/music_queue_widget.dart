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
           height: 60, width: 60,
           decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
           child: Image.network(music.cover!)),
         Padding(
           padding: const EdgeInsets.only(left:12),
           child: SizedBox(
             width:200,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(music.title, style: const TextStyle(fontSize: 24), textAlign: TextAlign.left, maxLines: 1),
                 Text(music.artists!.join(", "), style: const TextStyle(fontSize: 18), textAlign: TextAlign.left, maxLines: 1),
               ],
             ),
           ),
         ),
         IconButton(
            alignment: Alignment.center,
            iconSize: 26,
             onPressed: () {
             },
             icon: const Icon(Icons.delete_outline, color: Color(0xFFFFE681))
         ),
       ],
     ),
   );
  }
}
