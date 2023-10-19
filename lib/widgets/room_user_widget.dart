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
  BorderRadiusGeometry? bottomWidgetBorder = const BorderRadius.vertical(bottom: Radius.circular(7.0));
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
    final snapshot = await AppUser.collectionRef.doc(widget.userID).get();
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
                child: Image.asset(user.photoUrl),
              );
            }

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
                          bottomWidgetBorder = const BorderRadius.vertical(bottom: Radius.circular(7.0));
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFFFFECA1), borderRadius: widgetBorder),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 40, width: 40,
                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                              child: photo
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(user.displayName, style: const TextStyle(color: Colors.black, fontSize: 18),),
                            ),
                          ]
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Access music queue", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["room"]["queue"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["room"]["queue"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Access chat page", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["room"]["chat"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["room"]["chat"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Access users page", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["room"]["users"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["room"]["users"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Change room settings", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["room"]["settings"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["room"]["settings"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Delete room", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["room"]["delete_room"],
                                              onChanged: (value) {
                                               setState(() {
                                                 _room.members[widget.userID]["room"]["delete_room"] = value;
                                               });
                                              }
                                            )
                                          ],
                                        ),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Change permissions", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["users"]["change_permissions"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["users"]["change_permissions"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Kick users", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["users"]["kick_user"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["users"]["kick_user"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Ban users", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["users"]["ban_user"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["users"]["ban_user"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
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
                              if (!_permPlayer) {
                                bottomWidgetBorder = const BorderRadius.vertical(bottom: Radius.circular(7.0));
                              } else {
                                bottomWidgetBorder = BorderRadius.zero;
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: const Color(0xFFFFF2C0), borderRadius: bottomWidgetBorder),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Add music", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["add_music"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["add_music"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Remove music", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["remove_music"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["remove_music"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Change music order", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["change_music_order"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["change_music_order"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Restart music", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["restart_music"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["restart_music"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Next music", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["next_music"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["next_music"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Resume/Pause music", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["pause_play_music"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["pause_play_music"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Text("Change music position", style: TextStyle(color: Colors.black, fontSize: 16),),
                                            ),
                                            Switch(
                                              value: _room.members[widget.userID]["player"]["change_position"],
                                              onChanged: (value) {
                                                setState(() {
                                                  _room.members[widget.userID]["player"]["change_position"] = value;
                                                });
                                              }
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
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