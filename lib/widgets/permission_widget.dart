import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class PermissionWidget extends StatefulWidget {
  final List<String> permissions;
  final Room room;
  final String userID;
  final String text;
  const PermissionWidget({super.key, required this.permissions, required this.userID, required this.text, required this.room});

  @override
  State<StatefulWidget> createState() => _PermissionWidget();
}

class _PermissionWidget extends State<PermissionWidget> {
  late final Room _room;
  late List<String> permissions;
  late String userID;
  late String text;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    permissions = widget.permissions;
    userID = widget.userID;
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 16),),
          ),
          Switch(
            value: _room.members[userID][permissions[0]][permissions[1]],
            onChanged: (value) {
              if (userID == FirebaseAuth.instance.currentUser!.uid || userID == _room.host || !_room.members[userID]["users"]["change_permissions"] || !_room.members[userID][permissions[0]][permissions[1]]) {
                ToastUtil.showShortErrorToast(context, "Not permitted");
              } else {
                setState(() {
                  _room.members[userID][permissions[0]][permissions[1]] = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

}