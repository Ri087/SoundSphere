import 'package:SoundSphere/models/user.dart';
import 'package:SoundSphere/widgets/room.dart';
import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Room {
  final String? title;
  final String? description;
  final int? maxMembers;
  final List<String>? members;
  final bool? isPrivate;

  Room({this.title, this.description, this.maxMembers, this.members, this.isPrivate});

  Widget? getWidget() {
    return null;
  }

  static Future<Room?> getRoom(String docId) async {
    final ref = AppFirebase.db.collection("room").doc(docId).withConverter(
      fromFirestore: Room.fromFirestore,
      toFirestore: (Room room, _) => room.toFirestore(),
    );
    final docSnap = await ref.get();
    final room = docSnap.data();
    if (room != null) {
      print(room);
      return room;
    } else {
      print("No such document.");
      return null;
    }
  }

  static Future<List<Room>?> getPublicRooms() async {
    final collectionRef = await AppFirebase.db.collection("room").withConverter(
      fromFirestore: Room.fromFirestore,
      toFirestore: (Room room, _) => room.toFirestore(),
    ).where("state", isEqualTo: false).get();
    final rooms = collectionRef.docs.map((e) => e.data()).toList();
    if (rooms .isEmpty) {
      print(rooms);
      return rooms;
    } else {
      print("No such document.");
      return null;
    }
  }

  bool addMember(User user) {
    if (members?.length == maxMembers || members!.indexOf(user.uid) > 0) {
      return false;
    }
    
    members?.add(user.uid);
    return true;
  }

  bool removeMember(User user) {
    if (!members!.contains(user.uid)) {
      return false;
    }

    members?.add(user.uid);
    return true;
  }

  static Future<List<Widget>> getRoomWidgets(context) async {
    List<Widget> widgets = [];
    List<Room>? rooms = await Room.getPublicRooms();
    if (rooms != null) {
      for (var room in rooms) {
        widgets.add(RoomWidget(room: room).getWidget(context));
      }
    }
    return widgets;
  }

  factory Room.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Room(
      title: data?["title"],
      description: data?["description"],
      maxMembers: data?["max_members"],
      members: data?["members"],
      isPrivate: data?["is_private"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (maxMembers != null) "max_members": maxMembers,
      if (members != null) "members": members,
      if (isPrivate != null) "is_private": isPrivate,
    };
  }
}