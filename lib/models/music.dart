import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/widgets/music_search_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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

  static final collectionRef = AppFirebase.db.collection("musics").withConverter(
    fromFirestore: Music.fromFirestore,
    toFirestore: (Music music, _) => music.toFirestore(),);

  static Future<Music?> getActualMusic(Room room) async {
    if (room.actualMusic!.isEmpty) {
      return null;
    }
    final docSnap = await collectionRef.doc(room.actualMusic).get();
    final music = docSnap.data();
    if (music != null) {
      return music;
    } else {
      return null;
    }
  }
  
  static Future<List<Widget>> getMusicsSearchWidgets(context, String search, Room room) async {
    List<Widget> widgets = [];
    List<Music?>? musics = await Music.getDbMusics(search);
    if (musics != null) {
      for (var music in musics) {
        widgets.add(MusicSearchWidget(music: music!, room: room).getWidget(context));
      }
    }
    return widgets;
  }
  
  static Future<List<Music?>?> getDbMusics(String search) async {
    final snap = await collectionRef.get();
    final musics = snap.docs.map((e) {Music data = e.data(); if (data.title!.startsWith(search)) return data;}).toList();
    if (musics.isNotEmpty) {
      return musics;
    } else {
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