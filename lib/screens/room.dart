import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/screens/search_music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/app_utilities.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  const RoomPage({super.key, required this.room});

  @override
  State<StatefulWidget> createState() => _RoomPage(room: room);
}

class _RoomPage extends State<RoomPage> {
  final Room room;
  late Future<Music?> actualMusic;
  late final AudioPlayer audioPlayer = AudioPlayer(playerId: room.id);
  Music? music;
  bool _isPlaying  = false;
  Duration _duration = const Duration(minutes: 0, seconds: 0);
  Duration _position = const Duration(minutes: 0, seconds: 0);

  _RoomPage({required this.room});

  @override
  void initState() {
    super.initState();
    actualMusic = Music.getActualMusic(room);
    audioPlayer.setVolume(1.0);

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
        reloadMusic();
      });
    });

    // Event pour mettre à jour une progress bar par exemple
    audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        _position = duration;
      });
    });

    // Event quand la musique est mis en pause ou resume etc...
    audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      setState(() {
        if (playerState == PlayerState.playing) {
          _isPlaying = true;
        } else {
          _isPlaying = false;
        }
      });
    });

    // Event quand la musique se termine (hors pause ou stop par user)
    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = const Duration(seconds: 0);
        room.nextMusic(audioPlayer);
      });
    });
  }

  void reloadMusic() {
    setState(() {
      actualMusic = Music.getActualMusic(room);
    });
  }

  void _pause(){
    audioPlayer.pause();
  }

  void _play(Music? music){
    if (audioPlayer.state == PlayerState.stopped) {
      if (music != null) {
        audioPlayer.play(UrlSource(music.url!));
      }
    } else {
      audioPlayer.resume();
    }
  }

  void leaveRoom() {
    audioPlayer.dispose();
    room.removeMember(FirebaseAuth.instance.currentUser!.uid);
    Navigator.pop(context);
  }

  Future openPopUpSettings() => showDialog(
    context: context,
    builder:(context)=> AlertDialog(
      alignment: Alignment.topCenter,
      content: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFF86C9)), borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      // ADD CODE
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top : 25),
                  child: Text('Settings', textDirection: TextDirection.ltr, style: TextStyle(fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.w400, height: 0,),),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF86C9)),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.lock_open,
                        color: Color(0xFFFF86C9),
                        size: 26,
                      ),
                      onPressed: () {
                        // ADD CODE
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top :25),
                    child: Text(
                      'Delete Sphere',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF02203A),
        leading: BackButton(
          onPressed: () => leaveRoom(),
        ),
        title: Text(room.title!, style: const TextStyle(fontFamily: 'ZenDots', fontSize: 18),),
        actions: [
          IconButton(
            onPressed: () {openPopUpSettings();}, icon: const Icon(Icons.settings),)
        ],
      ),
      body: FutureBuilder(
        future: actualMusic,
        builder: (context, snapshot) {
          String title = "No music in queue...", artists = "No music in queue...";
          Widget cover = const Icon(Icons.music_note, size: 60);
          Music? music;
          if (snapshot.hasData) {
            music = snapshot.data;
            if (music == null || music.url == null || music.url!.isEmpty) {
              title = "No music in queue...";
              artists = "No music in queue...";
            } else {
              cover = Image.network(music.cover!);
              title = music.title!;
              artists = AppUtilities.getArtists(music.artists!);
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text("Hosted by Jeremy", style: TextStyle(fontSize: 16),),
                  ),
                  Text("code: ${room.code}"),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 200, width: 200,
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
                          onChanged: (value) {
                            setState(() {
                              audioPlayer.seek(Duration(seconds: value.toInt()));
                            });
                          }
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
                          iconSize: 30,
                          icon: const Icon(Icons.skip_previous_outlined, color: Color(0xFFFFE681)),
                          onPressed: () {
                            setState(() {
                              audioPlayer.seek(const Duration(seconds: 0));
                            });
                          },
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFF86C9),
                          radius: 30,
                          child: IconButton(
                            iconSize: 30,
                            icon: Icon(_isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined, color: const Color(0xFF02203A),),
                            onPressed: _isPlaying ? () => _pause() : () => _play(music),
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.skip_next_outlined, color: Color(0xFFFFE681)),
                          onPressed: () {
                            room.nextMusic(audioPlayer);
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
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchMusic(room: room, audioPlayer: audioPlayer,)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}