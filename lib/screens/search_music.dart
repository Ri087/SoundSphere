import 'package:flutter/material.dart';

import '../models/music.dart';
import '../models/room.dart';

class SearchMusic extends StatefulWidget {
  const SearchMusic({super.key, required this.room});
  final Room room;

  @override
  State<StatefulWidget> createState() => _SearchMusic();
}

class _SearchMusic extends State<SearchMusic> {
  late final Room room;
  late Future<List<Widget>> searchMusicWidgets;
  TextEditingController searchController = TextEditingController();
  bool typing = false;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    searchMusicWidgets = Music.getMusicsSearchWidgets("", room);
  }

  void leavePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF86C9), //const Color(0xFF0EE6F1),
        title: typing ? TextField(
          autofocus: true,
          controller: searchController,
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            setState(() {
              searchMusicWidgets = Music.getMusicsSearchWidgets(value, room);
            });
          },
          decoration: InputDecoration(
            hintText: 'Search a music',
            filled: true,
            fillColor: const Color(0xFF02203A),
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          ),
        ) : TextButton(onPressed: (){setState(() {typing = !typing;});}, child: const Text("Click here to search a music", style: TextStyle(fontSize: 16)),),
        leading: BackButton(
          onPressed: () {
            leavePage();
          },
        ),
      ),

      body: FutureBuilder(
        future: searchMusicWidgets,
        builder: (context, snapshot) {
          List<Widget> musicsWidgets;
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {musicsWidgets = snapshot.data!;}
            else {
              musicsWidgets = [const Text("An error has occured")];
            }
          } else if (snapshot.hasError) {
            musicsWidgets = [const Text("An error has occured")];
          } else {
            musicsWidgets = [
              SizedBox(
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height-50,
                child: const Center(
                  child: SizedBox(
                    width: 75, height: 75,
                    child: CircularProgressIndicator(
                      color: Color(0xFF0EE6F1)
                    ),
                  ),
                ),
              ),
            ];
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: ListView.builder(
                itemCount: musicsWidgets.length,
                itemBuilder: (ctxt, ind) {
                  return musicsWidgets[ind];
                },
              ),
            ),
          );
        },
      ),
    );
  }
}