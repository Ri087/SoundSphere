import 'dart:async';

import 'package:SoundSphere/screens/search_music.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/music.dart';
import '../models/room.dart';
import '../widgets/toast.dart';

class Queue extends StatefulWidget {
  const Queue({super.key, required this.room, required this.roomStream});
  final Room room;
  final StreamSubscription roomStream;

  @override
  State<StatefulWidget> createState() => _Queue();
}

class _Queue extends State<Queue> {
  late Room _room;
  late Future<List<Widget>> _queueWidgets;
  TextEditingController searchController = TextEditingController();
  bool typing = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _queueWidgets = Music.getMusicQueueWidgets(_room, context);
  }

  void reloadData() {
    setState(() {
      _room = widget.room;
      _queueWidgets = Music.getMusicQueueWidgets(_room, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF86C9), //const Color(0xFF0EE6F1),
        title: const Text("Music Queue", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        backgroundColor: const Color(0xFF0EE6F1),
        color: Colors.white,
        onRefresh: () async {
          setState(() {
            _queueWidgets = Music.getMusicQueueWidgets(_room, context);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 12),
          child: FutureBuilder(
            future:  _queueWidgets,
            builder: (context, snapshot) {
              List<Widget> listItems;
              if (snapshot.hasData) {
                listItems = snapshot.data!;
              } else if (snapshot.hasError) {
                listItems = [Text("Result : ${snapshot.error}")];
              } else {
                listItems = [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - AppBar().preferredSize.height-125,
                    child: const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(color: Color(0xFF0EE6F1)),
                      ),
                    ),
                  ),
                ];
              }
              if (listItems.isEmpty) {
                return SizedBox(
                  height : MediaQuery.of(context).size.height - AppBar().preferredSize.height-125,
                  child :
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_music, size: 125,),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("The queue is empty", style: TextStyle(fontSize: 22),),
                            ),
                            Text("Use the '+' button to add a music to the queue."),
                            Text("If no musics appear, try to refresh!")
                          ],
                        ),
                      ),
                    ),
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - AppBar().preferredSize.height-125,
                  child: ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        key: Key("$index"),
                        title: listItems[index],
                      );
                    },
                    itemCount: listItems.length,
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final Widget item = listItems.removeAt(oldIndex);
                        listItems.insert(newIndex, item);
                      });
                    }
                  )
                );
              }
            }
          ),
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_room.members[FirebaseAuth.instance.currentUser!.uid]["player"]["add_music"]) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchMusic(room: _room)))
                .whenComplete(() {
              setState(() {
                _queueWidgets = Music.getMusicQueueWidgets(_room, context);
              });
            });
          } else {
            ToastUtil.showShortErrorToast(context, "Not permitted");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}