import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _nameController = TextEditingController();
  late bool _isPrivate;
  late int _maxMembers;
  late bool _visibility;

  bool typing = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _nameController.text = _room.title;
    _isPrivate = _room.isPrivate;
    _maxMembers = _room.maxMembers;
    _visibility = (_room.maxMembers != _maxMembers || (_room.title != _nameController.text.toUpperCase().trim() && _nameController.text.toUpperCase().trim() != "") || _room.isPrivate != _isPrivate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0EE6F1),
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Sphere title :", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 8),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Sphere title",
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color(0xFF0EE6F1), style: BorderStyle.solid,),),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(width: 2, color: Color(0xFF0EE6F1), style: BorderStyle.solid,))
                          ),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            setState(() {
                              _visibility = (_room.maxMembers != _maxMembers || (_room.title != value.toUpperCase().trim() && value.toUpperCase().trim() != "") || _room.isPrivate != _isPrivate);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Visibility :", style: TextStyle(color: Colors.white, fontSize: 16),),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_open, color: Colors.white, size: 25,),
                          Switch(
                              activeColor: const Color(0xFFFF86C9),
                              value: _isPrivate,
                              onChanged: (value) {
                                setState(() {
                                  _isPrivate = value;
                                  _visibility = (_room.maxMembers != _maxMembers || (_room.title != _nameController.text.toUpperCase().trim() && _nameController.text.toUpperCase().trim() != "") || _room.isPrivate != _isPrivate);
                                });
                              }
                          ),
                          const Icon(Icons.lock, color: Colors.white, size: 25,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Max users :", style: TextStyle(color: Colors.white, fontSize: 16),),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_maxMembers > 1) {
                                _maxMembers--;
                                _visibility = (_room.maxMembers != _maxMembers || (_room.title != _nameController.text.toUpperCase().trim() && _nameController.text.toUpperCase().trim() != "") || _room.isPrivate != _isPrivate);
                              }
                            });
                          },
                          icon: const Icon(Icons.remove, color: Colors.white)
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Text(_maxMembers < 10 ? "0${_maxMembers.toString()}" : _maxMembers.toString(), style: const TextStyle(color: Colors.white),),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_maxMembers < 99) _maxMembers++;
                              _visibility = (_room.maxMembers != _maxMembers || (_room.title != _nameController.text.toUpperCase().trim() && _nameController.text.toUpperCase().trim() != "") || _room.isPrivate != _isPrivate);
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.white)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: () {
                  ToastUtil.showInfoToast(context, "Soon");
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(width: 2, color: Colors.red)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("CHANGE OWNER", style: TextStyle(fontSize: 18, color: Colors.red),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.compare_arrows_rounded, color: Colors.red,),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Visibility(
        visible: _visibility,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF0EE6F1),
          foregroundColor: Colors.black,
          onPressed: () {
            if (_room.members[FirebaseAuth.instance.currentUser!.uid]["room"]["settings"]) {
              _room.action = "change_settings";
              _room.isPrivate = _isPrivate;
              _room.maxMembers = _maxMembers;
              _room.title = _nameController.text.toUpperCase().trim();
              _room.update();
            }
          },
          child: const Icon(Icons.save,),
        ),
      ),
    );
  }
}