import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/utils/app_utilities.dart';
import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:SoundSphere/widgets/room_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Room {
  final String id;
  final String title;
  final String host;
  final bool isPrivate;
  final int maxMembers;
  Map<String, dynamic> members;
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
    required this.maxMembers,
    required this.members,
    this.isPrivate = false,
    this.action = "",
    this.updater = "",
  });

  static CollectionReference<Room> getCollectionRef() => AppFirebase.db.collection("rooms")
      .withConverter(fromFirestore: Room.fromFirestore, toFirestore:
  (Room room, _) => room.toFirestore(),);

  Future<void> addMusic(Music musicToAdd) async {
    action = "add_music";
    musicQueue.add(musicToAdd.id);
    await update();
  }

  Future<Music> getMusic() async {
    if (actualMusic["id"].toString().isEmpty) {
      return Music(url: "", duration: 0, artists: [], title: "", album: "", cover: "");
    }
    final docSnap = await Music.collectionRef.doc(actualMusic["id"]).get();
    if(docSnap.data() != null) {
      return docSnap.data()!;
    }
    return Music(url: "", duration: 0, artists: [], title: "", album: "", cover: "");
  }

  Future<Music> getNextMusic() async {
    if (musicQueue.isEmpty) {
      return Music(url: "", duration: 0, artists: [], title: "", album: "", cover: "");
    }
    else {
      final docSnap = await Music.collectionRef.doc(musicQueue[0]).get();
      if (docSnap.data() != null) {
        return docSnap.data()!;
      }
      return Music(url: "",
          duration: 0,
          artists: [],
          title: "",
          album: "",
          cover: "");
    }
  }

  static Future<Room?> getRoom(String docId) async {
    final docSnap = await getCollectionRef().doc(docId).get();
    return docSnap.data();
  }

  static Future<List<Room>?> getPublicRooms() async {
    final snap = await getCollectionRef().where("is_private", isEqualTo: false).get();
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
        members: {},
        musicQueue: [],
        actualMusic: {"id": "", "position": 0, "state": "", "timestamp": 0},
        title: title.toUpperCase(),
        isPrivate: isPrivate,
        maxMembers: maxMembers,
    );
    await getCollectionRef().doc(room.id).set(room);
    return room;
  }

  Future<bool> addMember(String uid) async {
    if (members.length == maxMembers) {
      return false;
    }

    if (!members.containsKey(uid)) {
      action = "user_join";
      if (uid == host) {
        members[uid] = {
          "room": {
            "queue": true,
            "users": true,
            "chat": true,
            "settings": true,
            "delete_room": true,
          },
          "users": {
            "change_permissions": true,
            "kick_user": true,
            "ban_user": true
          },
          "player": {
            "add_music": true,
            "remove_music": true,
            "change_music_order": true,
            "restart_music": true,
            "next_music": true,
            "pause_play_music": true,
            "change_position": true
          }
        };
      } else {
        if (isPrivate) {
          members[uid] = {
            "room": {
              "queue": true,
              "users": true,
              "chat": true,
              "settings": false,
              "delete_room": false
            },
            "users": {
              "change_permissions": false,
              "kick_user": false,
              "ban_user": false
            },
            "player": {
              "add_music": true,
              "remove_music": true,
              "change_music_order": true,
              "restart_music": true,
              "next_music": true,
              "pause_play_music": true,
              "change_position": true
            }
          };
        } else {
          members[uid] = {
            "room": {
              "queue": true,
              "users": false,
              "chat": false,
              "settings": false,
              "delete_room": false
            },
            "users": {
              "change_permissions": false,
              "kick_user": false,
              "ban_user": false
            },
            "player": {
              "add_music": false,
              "remove_music": false,
              "change_music_order": false,
              "restart_music": false,
              "next_music": false,
              "pause_play_music": false,
              "change_position": false
            }
          };
        }
      }
      await update();
    }
    return true;
  }

  Future<void> removeMember(String uid) async {
    if (!members.containsKey(uid)) {
      return;
    }
    action = "user_leave";
    members.remove(uid);
    await update();
  }

  Future<void> update() async {
    updater = FirebaseAuth.instance.currentUser!.displayName!;
    await getCollectionRef().doc(id).set(this);
  }

  factory Room.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Room(
      id: snapshot.id,
      title: data?["title"],
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