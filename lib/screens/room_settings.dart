import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomSettings extends StatefulWidget {
  const RoomSettings({super.key, required this.room});
  final Room room;

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<RoomSettings> {
  late final Room _room;
  TextEditingController searchController = TextEditingController();
  bool typing = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0EE6F1),
        title: const Text("Room settings", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [

        ],
      )
    );
  }
}