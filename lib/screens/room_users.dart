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

  @override
  void initState() {
    super.initState();
    _room = widget.room;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),

      body: Column(),
    );
  }

}