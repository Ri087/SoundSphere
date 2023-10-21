import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomSettings extends StatefulWidget {
  const RoomSettings({super.key, required this.room});
  final Room room;

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<RoomSettings> {
  late Room _room;
  late StreamSubscription<DocumentSnapshot> _roomStream;
  late Future<List<Widget>> _queueWidgets;
  TextEditingController searchController = TextEditingController();
  bool typing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0EE6F1),
        title: const Text("Manage Settings", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SizedBox(
        height : MediaQuery.of(context).size.height - AppBar().preferredSize.height-75,
        child :
            // TODO : Supprimer cette partie et développer la feature
        Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_task, size: 125,),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Feature available soon", style: TextStyle(fontSize: 22),),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}