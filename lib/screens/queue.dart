import 'package:SoundSphere/screens/search_music.dart';
import 'package:flutter/material.dart';

import '../models/music.dart';
import '../models/room.dart';

class Queue extends StatefulWidget {
  const Queue({super.key, required this.room});
  final Room room;

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
    _queueWidgets = Music.getMusicQueueWidgets(_room);
  }

  void leavePage() {
    Navigator.pop(context);
  }

  void reloadData() {
    setState(() {
      _queueWidgets = Music.getMusicQueueWidgets(_room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF86C9), //const Color(0xFF0EE6F1),
        title: Text("Music Queue", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            leavePage();
          },
        ),
      ),

      body: Column(
        children: [
          RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            backgroundColor: const Color(0xFF0EE6F1),
            color: Colors.white,
            onRefresh: () async {
              reloadData();
            },
            child: Padding(
              padding: const EdgeInsets.only(top : 10),
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
                          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
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
                        height : MediaQuery.of(context).size.height - AppBar().preferredSize.height-75,
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
                          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height-50,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: listItems.length,
                                  itemBuilder: (ctxt, ind) {
                                    return listItems[ind];
                                  }
                              )
                          )
                      );
                    }
                  }
              ),
            )
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_isUpdater = true;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchMusic(room: _room)))
              .whenComplete(() {
            setState(() {
              //_actualMusic = _room.getMusic();
              //_nextMusic = _room.getNextMusic();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}