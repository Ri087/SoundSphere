import 'dart:math';

import 'package:SoundSphere/models/user.dart';
import 'package:SoundSphere/widgets/room_widget.dart';
import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Room {
  final String? id;
  final String? code;
  final String? title;
  final String? description;
  final String? host;
  final int? maxMembers;
  final List<dynamic>? members;
  final bool? isPrivate;
  final String? actualMusic;
  final List<dynamic>? musicQueue;

  static CollectionReference<Room> collectionRef = AppFirebase.db.collection("room")
      .withConverter(fromFirestore: Room.fromFirestore, toFirestore:
      (Room room, _) => room.toFirestore(),);

  Room({this.id, required this.code, required this.host, required this.musicQueue, this.actualMusic, this.title, this.description, this.maxMembers, this.members, this.isPrivate});

  Future<void> nextMusic() async {

  }

  static Future<Room?> getRoom(String docId) async {
    final docSnap = await collectionRef.doc(docId).get();
    final room = docSnap.data();
    if (room != null) {
      return room;
    } else {
      print("No such document.");
      return null;
    }
  }

  static Future<List<Room>?> getPublicRooms() async {
    final snap = await collectionRef.where("is_private", isEqualTo: false).get();
    final rooms = snap.docs.map((e) => e.data()).toList();
    if (rooms.isNotEmpty) {
      return rooms;
    } else {
      print("No such document.");
      return null;
    }
  }

  static Future<bool> createSphere(String _title, String _description, bool _isPrivate, int _maxMembers) async {
    String usr = FirebaseAuth.instance.currentUser!.uid;
    final room = Room(code: "S-${getRandomString(3)}", host: usr, musicQueue: [], actualMusic: "", description: _description, title: _title, isPrivate: _isPrivate, members: [], maxMembers: _maxMembers);
    await collectionRef.doc().set(room);
    return true;
  }

  Future<bool> addMember(String uid) async {
    if (members?.length == maxMembers || members!.contains(uid)) {
      return false;
    }
    members?.add(uid);
    await collectionRef.doc(id).set(this);
    return true;
  }

  Future<bool> removeMember(String uid) async {
    if (!members!.contains(uid)) {
      return false;
    }
    members?.remove(uid);
    await collectionRef.doc(id).set(this);
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
      if (code != null) "code": code,
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (maxMembers != null) "max_members": maxMembers,
      if (members != null) "members": members,
      if (isPrivate != null) "is_private": isPrivate,
      if (actualMusic != null) "actual_music": actualMusic,
      if (musicQueue != null) "music_queue": musicQueue,
      if (host != null) "host": host,
    };
  }
}