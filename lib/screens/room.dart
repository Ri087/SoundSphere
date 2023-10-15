
import 'dart:async';

import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/screens/search_music.dart';
import 'package:SoundSphere/widgets/popup/popup_room_settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/app_utilities.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  const RoomPage({super.key, required this.room});

  @override
  State<StatefulWidget> createState() => _RoomPage();
}

class _RoomPage extends State<RoomPage> {
  late Room _room;
  late Future<Music?> _actualMusic;
  late final AudioPlayer _audioPlayer = AudioPlayer();
  late Music _music;
  late final StreamSubscription _roomStream;
  late final Future<AppUser> _host;
  bool _isPlaying  = false;
  Duration _duration = const Duration(seconds: 0);
  Duration _position = const Duration(seconds: 0);


  @override
  void initState() {
    super.initState();

    _room = widget.room;

    // permet de mettre à jour la room selon les intéractions d'autres utilisateurs
    _roomStream = Room.collectionRef.doc(_room.id).snapshots().listen((event) {
       if (event.data() != null) {
         Room newRoom = event.data()!;
         if (newRoom.actualMusic["last_updater"].toString() == FirebaseAuth.instance.currentUser!.uid) {
           return;
         }
       }
     }, onError: (error) => print("Listen failed: $error"));

    _actualMusic = Music.getActualMusic(_room);
    _host = _room.getHost();

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
        reloadMusic();
      });
    });

    // mise à jour progress bar
    _audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        _position = duration;
      });
    });

    // Event quand la musique est mis en pause ou resume etc...
    _audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      setState(() {
        if (playerState == PlayerState.playing) {
          _isPlaying = true;
        } else {
          _isPlaying = false;
        }
      });
    });

    // Event quand la musique se termine (hors pause ou stop par user)
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = const Duration(seconds: 0);
        _room.nextMusic(_audioPlayer);
      });
    });
  }

  @override
  void dispose() {
    _roomStream.cancel();
    super.dispose();
  }

  void reloadMusic() {
    setState(() {
      _actualMusic = Music.getActualMusic(_room);
    });
  }

  void _pause() {
    _audioPlayer.pause();
  }

  void _play(Music? music) {
    print(_audioPlayer.state);
    if (_audioPlayer.state == PlayerState.stopped) {
      if (music != null) {
        _audioPlayer.play(UrlSource(music.url));
      }
    } else {
      _audioPlayer.resume();
    }
  }

  void leaveRoom() {
    _audioPlayer.dispose();
    _room.removeMember(FirebaseAuth.instance.currentUser!.uid);
    Navigator.pop(context);
  }

  Future openPopupSettings() => showDialog(
    context: context,
    builder:(context)=> const PopupRoomSettings(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF02203A),
        leading: BackButton(onPressed: () => leaveRoom(),),
        title: Text(_room.title, style: const TextStyle(fontFamily: 'ZenDots', fontSize: 18),),
        actions: [
          IconButton(
            onPressed: () {openPopupSettings();}, icon: const Icon(Icons.settings),)
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder(
            future: _actualMusic,
            builder: (context, snapshot) {
              String title = "No music in queue...", artists = "No music in queue...";
              Widget cover = const Icon(Icons.music_note, size: 60);
              Music? music;
              if (snapshot.hasData) {
                music = snapshot.data;
                if (music == null || music.url.isEmpty) {
                  title = "No music in queue...";
                  artists = "No music in queue...";
                } else {
                  cover = Image.network(music.cover!);
                  title = music.title;
                  artists = music.artists!.join(", ");
                }
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("An error as occured : ${snapshot.error}")
                  ],
                );
              } else {
                title = "Loading music...";
                artists = "Loading music...";
              }
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: FutureBuilder(
                      future: _host,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text("Hosted by ${snapshot.data!.displayName}", style: const TextStyle(fontSize: 16),);
                        } else if (snapshot.hasError) {
                          return const Text("Error loading host", style: TextStyle(fontSize: 16),);
                        } else {
                          return const Text("Loading host", style: TextStyle(fontSize: 16),);
                        }
                      },
                    ),
                  ),
                  Text("code: ${_room.id}"),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 180, width: 180,
                      decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      child: cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(title, style: const TextStyle(fontSize: 22), ),
                  ),
                  Text(artists),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(AppUtilities.formatedTime(timeInSecond: _position.inSeconds.toInt()), style: const TextStyle(color: Colors.blueGrey, fontSize: 10),),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          value: _position.inSeconds.toDouble(),
                          onChanged: (value) => _audioPlayer.seek(Duration(seconds: value.toInt())),
                        ),
                      ),
                      Text(AppUtilities.formatedTime(timeInSecond: _duration.inSeconds.toInt()), style: const TextStyle(color: Colors.blueGrey, fontSize: 10),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          iconSize: 27,
                          icon: const Icon(Icons.skip_previous_outlined, color: Color(0xFFFFE681)),
                          onPressed: () => _audioPlayer.seek(const Duration(seconds: 0)),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFF86C9),
                          radius: 27,
                          child: IconButton(
                            iconSize: 27,
                            icon: Icon(_isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined, color: const Color(0xFF02203A),),
                            onPressed: _isPlaying ? () => _pause() : () => _play(_music),
                          ),
                        ),
                        IconButton(
                          iconSize: 27,
                          icon: const Icon(Icons.skip_next_outlined, color: Color(0xFFFFE681)),
                          onPressed: () {
                            _room.nextMusic(_audioPlayer);
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF0EE6F1), width: 2))),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text("Music queue",),
                          )
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchMusic(room: _room, audioPlayer: _audioPlayer,)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}