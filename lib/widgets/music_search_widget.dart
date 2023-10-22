import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/screens/loading_page.dart';
import 'package:SoundSphere/utils/youtube_download.dart';
import 'package:flutter/material.dart';

import '../utils/app_firebase.dart';

class MusicSearchWidget extends StatelessWidget {
  final Music music;
  final Room room;
  const MusicSearchWidget({super.key, required this.music, required this.room});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.network(music.cover!, height: 50, width: 50,errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.music_note, size: 25);
            },),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(music.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(music.artists!.join(", "), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const LoadingPage(text: "Loading music...")));
                if (music.url == "") {
                  await AppFirebase.musicsStorageRef.child('${music.id}.mp3').getDownloadURL().then((value) {
                    music.url = value;
                  }).onError((error, stackTrace) async {
                    await YoutubeDownload.addMusicInDb(music, context).then((value) {
                      music.url = value;
                    });
                  });
                  await Music.collectionRef.doc(music.id).set(music);
                }
                Navigator.pop(context);
                room.addMusic(music);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.add, color: Color(0xFF0EE6F1), size: 30,),
              ),
            ),
          )
        ],
      ),
    );
  }
}