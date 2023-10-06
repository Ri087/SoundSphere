import 'package:flutter/material.dart';

import '../models/music.dart';
import '../models/room.dart';

class SearchMusic extends StatefulWidget {
  const SearchMusic({super.key, required this.room});
  final Room room;

  @override
  State<StatefulWidget> createState() => _SearchMusic(room: room);
}

class _SearchMusic extends State<SearchMusic> {
  _SearchMusic({required this.room});
  final Room room;
  late Future<List<Widget>> searchMusicWidgets;
  TextEditingController searchController = TextEditingController();
  bool typing = false;

  @override
  void initState() {
    super.initState();
    searchMusicWidgets = Music.getMusicsSearchWidgets(context, "", room);
  }

  void leavePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02203A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF86C9), //const Color(0xFF0EE6F1),
        title: typing ? TextField(
          autofocus: true,
          controller: searchController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (value) {
            setState(() {
              searchMusicWidgets = Music.getMusicsSearchWidgets(context, searchController.value.toString(), room);
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
        ) : TextButton(onPressed: (){setState(() {typing = !typing;});}, child: const Text("Click here to search a music", style: TextStyle(color: Colors.white, fontSize: 16)),),
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
              const SizedBox(
                height: 500,
                child: Center(
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
            height: MediaQuery.of(context).size.height - 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: musicsWidgets.length,
                itemBuilder: (ctxt /*context*/, ind) {
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