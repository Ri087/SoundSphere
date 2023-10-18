import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/widgets/music_queue_widget.dart';
import 'package:SoundSphere/widgets/music_search_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../utils/app_firebase.dart';

class Music {
  final String? id;
  final String title;
  final String url;
  final int duration;
  final List<dynamic>? artists;
  final String? album;
  final String? cover;

  Music({
    this.id,
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

  static Future<Map<String, Music?>?> getMusicQueue(Room room) async {
    if (room.musicQueue.isEmpty) {
      return null;
    }
    final docSnap = await collectionRef.where("id",whereIn: room.musicQueue).get();
    Map<String, Music?> returnMap = {};
    for (var doc in docSnap.docs) {
      returnMap[doc.data().id!] = doc.data();
    }
    return returnMap;
  }

  static Future<List<Widget>> getMusicQueueWidgets(Room room) async {
    List<Widget> widgets = [];
    Map<String, Music?>? musicQueue = await Music.getMusicQueue(room);
    if (musicQueue == null) return [];
    for (var musicID in room.musicQueue) {
      widgets.add(MusicQueueWidget(music: musicQueue[musicID]!));
    }
    return widgets;
  }
  
  static Future<List<Widget>> getMusicsSearchWidgets(String search, Room room) async {
    List<Widget> widgets = [];
    List<Music?> musics = await Music.getDbMusics(search);
    for (var music in musics) {
      widgets.add(MusicSearchWidget(music: music!, room: room));
    }
    return widgets;
  }
  
  static Future<List<Music?>> getDbMusics(String search) async {
    final snap = await collectionRef.get();
    return snap.docs.map((e) {Music data = e.data(); if (data.title.startsWith(search)) return data;}).toList();
  }

  factory Music.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,) {
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
      "Titre": title,
      "Url": url,
      "Duration": duration,
      if (artists != null) "Artists": artists,
      if (album != null) "Album": album,
      if (cover != null) "Cover": cover,
    };
  }
}