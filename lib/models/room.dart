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
  final String id;
  final String title;
  final String? description;
  final String host;
  final int maxMembers;
  List<dynamic> members;
  final bool isPrivate;
  List<dynamic> musicQueue;
  Map<String, dynamic> actualMusic;
  String action;
  String updater;

  Room({
    required this.id,
    required this.host,
    required this.musicQueue,
    required this.actualMusic,
    required this.title,
    this.description,
    required this.maxMembers,
    required this.members,
    this.isPrivate = false,
    this.action = "",
    this.updater = "",
  });


  static CollectionReference<Room> collectionRef = AppFirebase.db.collection("rooms")
      .withConverter(fromFirestore: Room.fromFirestore, toFirestore:
      (Room room, _) => room.toFirestore(),);

  Future<bool> nextMusic(AudioPlayer player) async {
    Music? music = await Music.getActualMusic(this);

    if (player.state == PlayerState.playing) {
      await player.stop();
    }

    await player.setSourceUrl(music!.url);
    await player.seek(const Duration(seconds: 0));
    await player.resume();
    return true;
  }

  Future<bool> addMusic(Music musicToAdd, AudioPlayer audioPlayer) async {
    action = "add_music";
    musicQueue.add(musicToAdd.id);
    await update();
    return true;
  }

  static Future<Room?> getRoom(String docId) async {
    final docSnap = await collectionRef.doc(docId).get();
    return docSnap.data();
  }

  static Future<List<Room>?> getPublicRooms() async {
    final snap = await collectionRef.where("is_private", isEqualTo: false).get();
    final rooms = snap.docs.map((e) => e.data()).toList();
    // Trie desc du nombre de user dans une room
    rooms.sort((previous, next) => next.members.length.compareTo(previous.members.length));
    return rooms;
  }

  static Future<List<Widget>> getPublicRoomWidgets(void Function() onReturn) async {
    List<Widget> widgets = [];
    List<Room>? rooms = await Room.getPublicRooms();
    if (rooms != null) {
      for (var room in rooms) {
        widgets.add(RoomWidget(room: room, onReturn: onReturn,));
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
    String hostUID = FirebaseAuth.instance.currentUser!.uid;
    final Room room = Room(
        id: "S-${AppUtilities.getRandomString(5).toUpperCase()}",
        host: hostUID,
        members: [],
        musicQueue: [],
        actualMusic: {"id": "", "position": 0, "state": "", "timestamp": 0},
        description: description,
        title: title,
        isPrivate: isPrivate,
        maxMembers: maxMembers,
    );
    await collectionRef.doc(room.id).set(room);
    return room;
  }

  Future<bool> addMember(String uid) async {
    if (members.length == maxMembers) {
      return false;
    }

    if (!members.contains(uid)) {
      action = "user_join";
      members.add(uid);
      await update();
    }
    return true;
  }

  Future<bool> removeMember(String uid) async {
    if (!members.contains(uid)) {
      return false;
    }
    action = "user_leave";
    members.remove(uid);
    await update();
    return true;
  }

  Future<void> update() async {
    updater = FirebaseAuth.instance.currentUser!.displayName!;
    await collectionRef.doc(id).set(this);
  }

  factory Room.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Room(
      id: snapshot.id,
      title: data?["title"],
      description: data?["description"],
      maxMembers: data?["max_members"],
      members: data?["members"],
      isPrivate: data?["is_private"],
      actualMusic: data?["actual_music"],
      musicQueue: data?["music_queue"],
      host: data?["host"],
      action: data?["action"],
      updater: data?["updater"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      if (description != null) "description": description,
      "max_members": maxMembers,
      "members": members,
      "is_private": isPrivate,
      "actual_music": actualMusic,
      "music_queue": musicQueue,
      "host": host,
      "action": action,
      "updater": updater,
    };
  }
}