import 'package:flutter/cupertino.dart';

import '../models/app_user.dart';

class RoomUserWidget extends StatefulWidget {
  final String userID;
  final Map<String, dynamic> userPermissions;
  const RoomUserWidget({super.key, required this.userID, required this.userPermissions, });

  @override
  State<StatefulWidget> createState() => _RoomUserWidget();
}

class _RoomUserWidget extends State<RoomUserWidget> {
  late Future<AppUser> _user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Row(

      ),
    );
  }
}