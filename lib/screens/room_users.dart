import 'package:SoundSphere/widgets/room_user_widget.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomUsersPage extends StatefulWidget {
  final Room room;
  const RoomUsersPage({super.key, required this.room});

  @override
  State<StatefulWidget> createState() => _RoomUsersPage();
}

class _RoomUsersPage extends State<RoomUsersPage> {
  late final Room _room;

  List<Widget> getUsersWidgets() {
    List<Widget> usersWidgets = [];
    _room.members.forEach((key, value) {
      usersWidgets.add(RoomUserWidget(
        userID: key,
        userPermissions: value
      ));
    });
    return usersWidgets;
  }

  @override
  void initState() {
    super.initState();
    _room = widget.room;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE681),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Manage Users"),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: getUsersWidgets(),
        ),
      ),
    );
  }
}