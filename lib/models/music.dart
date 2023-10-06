import 'package:SoundSphere/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_firebase.dart';

class Music {
  final String? id;
  final String? title;
  final String? url;
  final int? duration;
  final List<dynamic>? artists;
  final String? album;
  final String? cover;

  Music({
    required this.id,
    required this.url,
    required this.duration,
    required this.artists,
    required this.title,
    required this.album,
    required this.cover
  });

  static Future<Music?> getActualMusic(Room room) async {
    final ref = AppFirebase.db.collection("musics").doc(room.actualMusic).withConverter(
      fromFirestore: Music.fromFirestore,
      toFirestore: (Music music, _) => music.toFirestore(),
    );
    final docSnap = await ref.get();
    print(docSnap.id);
    final music = docSnap.data();
    if (music != null) {
      return music;
    } else {
      print("No such document.");
      return null;
    }
  }

  factory Music.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Music(
      id: snapshot.id,
      title: data?["Titre"],
      url: data?["Url"],
      duration: data?["Duration"],
      artists: data?["Artists"],
      album: data?["Album"],
      cover: data?["Cover"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "Titre": title,
      if (url != null) "Url": url,
      if (duration != null) "Duration": duration,
      if (artists != null) "Artists": artists,
      if (album != null) "Album": album,
      if (cover != null) "Cover": cover,
    };
  }
}