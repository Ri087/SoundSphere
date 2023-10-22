import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/utils/youtube_download.dart';
import 'package:SoundSphere/widgets/music_queue_widget.dart';
import 'package:SoundSphere/widgets/music_search_widget.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_firebase.dart';

class Music {
  final String id;
  final String title;
  late String url;
  final int duration;
  final List<dynamic>? artists;
  final String? cover;

  Music({
    this.id = "",
    this.url = "",
    required this.duration,
    required this.artists,
    required this.title,
    required this.cover
  });

  static final collectionRef = AppFirebase.database.collection("musics").withConverter(
    fromFirestore: Music.fromFirestore,
    toFirestore: (Music music, _) => music.toFirestore(),);

  static Future<Map<String, Music?>?> getMusicQueue(Room room) async {
    if (room.musicQueue.isEmpty) {
      return null;
    }
    final docSnap = await collectionRef.where("id",whereIn: room.musicQueue.values).get();
    Map<String, Music?> returnMap = {};
    for (var doc in docSnap.docs) {
      returnMap[doc.data().id] = doc.data();
    }
    return returnMap;
  }

  static Future<List<Widget>> getMusicQueueWidgets(Room room, context) async {
    List<Widget> widgets = [];
    Map<String, Music?>? musicQueue = await Music.getMusicQueue(room);
    if (musicQueue == null) return [];
    room.musicQueue.forEach((key, value) {
      widgets.add(MusicQueueWidget(music: musicQueue[value]!, onClick: () {
        if (room.members[FirebaseAuth.instance.currentUser!.uid]["player"]["remove_music"]) {
          room.removeMusic(key);
        } else {
          ToastUtil.showShortErrorToast(context, "Not permitted");
        }
      },));
    });
    return widgets;
  }
  
  static Future<List<Widget>> getMusicsSearchWidgets(String search, Room room) async {
    List<Widget> widgets = [];
    List<Music> musics = [];
    if (search.isNotEmpty) {
      musics = await YoutubeDownload.getVideosResult(search);
    } else {
      musics = await YoutubeDownload.getMusicTrending();
    }
    for (var music in musics) {
      widgets.add(MusicSearchWidget(music: music, room: room));
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
      title: data?["title"],
      url: data?["url"],
      duration: data?["duration"],
      artists: data?["artists"],
      cover: data?["cover"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "title": title,
      "url": url,
      "duration": duration,
      "artists": artists,
      "cover": cover,
    };
  }
}