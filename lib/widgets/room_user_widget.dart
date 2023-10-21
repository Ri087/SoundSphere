import 'package:SoundSphere/widgets/permission_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/room.dart';

class RoomUserWidget extends StatefulWidget {
  final String userID;
  final Room room;
  const RoomUserWidget({super.key, required this.userID, required this.room, });

  @override
  State<StatefulWidget> createState() => _RoomUserWidget();
}

class _RoomUserWidget extends State<RoomUserWidget> {
  late Future<AppUser> _user;
  late final Room _room;
  BorderRadiusGeometry? widgetBorder = BorderRadius.circular(7.0);
  bool _permCategories = false;
  bool _permRoom = false;
  bool _permUsers = false;
  bool _permPlayer = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _user = getUser(widget.userID);
  }

  Future<AppUser> getUser(String uid) async {
    final snapshot = await AppUser.collectionRef.doc(uid).get();
    return snapshot.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _user,
        builder: (context, snapshot) {
          AppUser? user;
          if(snapshot.hasData) {
            user = snapshot.data!;
            Widget photo = const Icon(Icons.person_rounded, color: Colors.white,);
            if (user.photoUrl != "") {
              photo = ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(user.photoUrl),
              );
            }

            // Row différente si host
            List<Widget> userRow = [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                    height: 40, width: 40,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                    child: photo
                ),
              ),
            ];

            if (widget.userID == _room.host) {
              userRow.add(const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.star_outline_rounded, color: Colors.black,),
              ));
            }

            if (widget.userID == FirebaseAuth.instance.currentUser!.uid) {
              userRow.add(const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.person_outline_rounded, color: Colors.black,),
              ));
            }

            userRow.add(Text(user.displayName, style: const TextStyle(color: Colors.black, fontSize: 18),));

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _permCategories = !_permCategories;
                        if (_permCategories) {
                          widgetBorder = const BorderRadius.vertical(top: Radius.circular(7.0));
                        } else {
                          _permPlayer = false;
                          _permUsers = false;
                          _permRoom = false;
                          widgetBorder = BorderRadius.circular(7.0);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFFFFECA1), borderRadius: widgetBorder),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            children: userRow
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _permCategories,
                  maintainSize: false,
                  maintainAnimation: false,
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _permRoom = !_permRoom;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(color: Color(0xFFFFF2C0)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text("Room", style: TextStyle(fontSize: 16, color: Colors.black),),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _permRoom,
                                maintainSize: false,
                                maintainAnimation: false,
                                child: Container(
                                  decoration: const BoxDecoration(color: Color(0xFFFFF9E0)),
                                  child: Column(
                                    children: [
                                      PermissionWidget(
                                        permissions: const ["room", "queue"],
                                        userID: widget.userID,
                                        text: "Access music queue",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["room", "chat"],
                                        userID: widget.userID,
                                        text: "Access chat page",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["room", "users"],
                                        userID: widget.userID,
                                        text: "Access users page",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["room", "settings"],
                                        userID: widget.userID,
                                        text: "Access settings page",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["room", "delete_room"],
                                        userID: widget.userID,
                                        text: "Delete room",
                                        room: _room,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _permUsers = !_permUsers;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(color: Color(0xFFFFF2C0)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text("Users", style: TextStyle(fontSize: 16, color: Colors.black),),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _permUsers,
                                maintainSize: false,
                                maintainAnimation: false,
                                child: Container(
                                  decoration: const BoxDecoration(color: Color(0xFFFFF9E0)),
                                  child: Column(
                                    children: [
                                      PermissionWidget(
                                        permissions: const ["users", "change_permissions"],
                                        userID: widget.userID,
                                        text: "Change permissions",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["users", "kick_user"],
                                        userID: widget.userID,
                                        text: "Kick users",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["users", "ban_user"],
                                        userID: widget.userID,
                                        text: "Ban users",
                                        room: _room,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _permPlayer = !_permPlayer;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(color: Color(0xFFFFF2C0)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text("Player", style: TextStyle(fontSize: 16, color: Colors.black),),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _permPlayer,
                                maintainSize: false,
                                maintainAnimation: false,
                                child: Container(
                                  decoration: const BoxDecoration(color: Color(0xFFFFF9E0), borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.0))),
                                  child: Column(
                                    children: [
                                      PermissionWidget(
                                        permissions: const ["player", "add_music"],
                                        userID: widget.userID,
                                        text: "Add music",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["player", "remove_music"],
                                        userID: widget.userID,
                                        text: "Remove music",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["player", "change_music_order"],
                                        userID: widget.userID,
                                        text: "Change music order",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["player", "restart_music"],
                                        userID: widget.userID,
                                        text: "Restart music",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["player", "next_music"],
                                        userID: widget.userID,
                                        text: "Next music",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["player", "pause_play_music"],
                                        userID: widget.userID,
                                        text: "Resume/Pause music",
                                        room: _room,
                                      ),
                                      PermissionWidget(
                                        permissions: const ["player", "change_position"],
                                        userID: widget.userID,
                                        text: "Change music position",
                                        room: _room,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Color(0xFFFFF2C0), borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.0))),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("L", style: TextStyle(fontSize: 16, color: Colors.black),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Error while loading user: ${snapshot.error}"),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Loading user..."),
            );
          }
        },
      ),
    );
  }
}