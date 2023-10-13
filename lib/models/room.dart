import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/utils/app_utilities.dart';
import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:SoundSphere/widgets/room_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Room {
  final String? id;
  final String code;
  final String title;
  final String? description;
  final String host;
  final int maxMembers;
  final List<dynamic> members;
  final bool isPrivate;
  String? actualMusic;
  final List<dynamic> musicQueue;

  static CollectionReference<Room> collectionRef = AppFirebase.db.collection("room")
      .withConverter(fromFirestore: Room.fromFirestore, toFirestore:
      (Room room, _) => room.toFirestore(),);

  Room({this.id, required this.code, required this.host, required this.musicQueue, this.actualMusic, required this.title, this.description, required this.maxMembers, required this.members, required this.isPrivate});

  Future<bool> nextMusic(AudioPlayer player) async {
    if (musicQueue.isNotEmpty) {
      actualMusic = musicQueue.first;
      musicQueue.removeAt(0);
      Music? music = await Music.getActualMusic(this);
      await collectionRef.doc(id).set(this);
      if (player.state == PlayerState.playing) {
        await player.stop();
      }
      await player.play(UrlSource(music!.url));
      return true;
    }
    return false;
  }

  Future<bool> addMusic(Music musicToAdd, AudioPlayer audioPlayer) async {
    bool playMusic = false;
    if (musicQueue.isEmpty && actualMusic!.isEmpty) {
      actualMusic = musicToAdd.id;
      playMusic = true;
    } else {
      musicQueue.add(musicToAdd.id);
    }
    await collectionRef.doc(id).set(this);
    if (playMusic) {
      await audioPlayer.play(UrlSource(musicToAdd.url));
    }
    return true;
  }

  static Future<Room?> getRoom(String docId) async {
    final docSnap = await collectionRef.doc(docId).get();
    return docSnap.data();
  }

  static Future<List<Room>?> getPublicRooms() async {
    final snap = await collectionRef.where("is_private", isEqualTo: false).get();
    final rooms = snap.docs.map((e) => e.data()).toList();
    return rooms;
  }

  static Future<List<Widget>> getPublicRoomWidgets() async {
    List<Widget> widgets = [];
    List<Room>? rooms = await Room.getPublicRooms();
    if (rooms != null) {
      for (var room in rooms) {
        widgets.add(RoomWidget(room: room));
      }
    }
    return widgets;
  }

  Future<AppUser> getHost() async {
    final user = await AppUser.collectionRef.doc(host).get();
    final userData = user.data()!;
    return AppUser(email: userData.email, displayName: userData.displayName);
  }

  static Future<Room> createSphere(String title, String description, bool isPrivate, int maxMembers) async {
    String hostUid = FirebaseAuth.instance.currentUser!.uid;
    final room = Room(code: "S-${AppUtilities.getRandomString(5)}", host: hostUid, musicQueue: [], actualMusic: "", description: description, title: title, isPrivate: isPrivate, members: [], maxMembers: maxMembers);
    await collectionRef.doc().set(room);
    return room;
  }

  Future<bool> addMember(String uid) async {
    if (members.length == maxMembers || members.contains(uid)) {
      return false;
    }
    members.add(uid);
    await collectionRef.doc(id).set(this);
    return true;
  }

  Future<bool> removeMember(String uid) async {
    if (!members.contains(uid)) {
      return false;
    }
    members.remove(uid);
    await collectionRef.doc(id).set(this);
    return true;
  }

  factory Room.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Room(
      id: snapshot.id,
      code: data?["code"],
      title: data?["title"],
      description: data?["description"],
      maxMembers: data?["max_members"],
      members: data?["members"],
      isPrivate: data?["is_private"],
      actualMusic: data?["actual_music"],
      musicQueue: data?["music_queue"],
      host: data?["host"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "code": code,
      "title": title,
      if (description != null) "description": description,
      "max_members": maxMembers,
      "members": members,
      "is_private": isPrivate,
      "actual_music": actualMusic,
      "music_queue": musicQueue,
      "host": host,
    };
  }
}