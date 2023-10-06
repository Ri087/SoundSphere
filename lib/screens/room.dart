import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/screens/search_music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomPage extends StatefulWidget {
  final Room room;

  const RoomPage({super.key, required this.room});

  @override
  State<StatefulWidget> createState() => _RoomPage(room: room);
}

class _RoomPage extends State<RoomPage> {
  final Room room;
  late Future<Music?> actualMusic;
  double _sliderValue = 0;
  late final AudioPlayer audioPlayer;
  IconData playerButtonState = Icons.play_arrow_outlined;
  bool _isPlaying  = false;
  Duration _duration = const Duration(minutes: 0, seconds: 0);
  Duration _postion = const Duration(minutes: 0, seconds: 0);

  _RoomPage({required this.room});

  @override
  void initState() {
    super.initState();
    actualMusic = Music.getActualMusic(room);
    initPlayer();
  }

  void initPlayer() {
    audioPlayer = AudioPlayer(playerId: room.id);
    audioPlayer.setVolume(1.0);

    audioPlayer.onDurationChanged.listen((Duration duration) {
      
    });

    // Event pour mettre à jour une progress bar par exemple
    audioPlayer.onPositionChanged.listen((Duration duration) {

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
    });
  }

  void _pause(){
    audioPlayer.pause();
  }

  void _play(Music? music){
    if (audioPlayer.state == PlayerState.stopped) {
      if (music != null) {
        audioPlayer.play(AssetSource("musics/SpotifyMatecom_PartenaireParticulier_PartenaireParticulier.mp3"));
      }
    } else {
      audioPlayer.resume();
    }
  }

  void leaveRoom() {
    audioPlayer.dispose();
    Navigator.pop(context);
  }

  String getArtists(List<dynamic> artists) {
    String output = "";
    for (int i = 0; i < artists.length; i++) {
      output += artists[i];
      if (artists.last != artists[i]) {
        output += ", ";
      }
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02203A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF02203A),
        leading: BackButton(
          onPressed: () => leaveRoom(),
        ),
        title: Text(room.title!, style: const TextStyle(color: Colors.white, fontFamily: 'ZenDots', fontSize: 18),),
        actions: [
          IconButton(
            onPressed: () {}, icon: const Icon(Icons.settings, color: Color(0xffffffff),),)
        ],
      ),

      body: FutureBuilder(
        future: actualMusic,
        builder: (context, snapshot) {
          Music? music;
          if (snapshot.hasData) {
            music = snapshot.data!;
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("An error as occured : ${snapshot.error}")
              ],
            );
          }

          String title = "Loading music...", artists = "Loading artists...";
          Widget cover = Container(
            height: 200, width: 200,
            decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
            child: const Icon(Icons.music_note, size: 60, color: Colors.white,),
          );

          if (music != null) {
            cover = Container(
                height: 200, width: 200,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child: Image.network(music.cover!));

            title = music.title!;
            artists = getArtists(music.artists);
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text("Hosted by Jeremy", style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                  Text("code: ${room.code}", style: const TextStyle(color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(title, style: const TextStyle(fontSize: 22, color: Colors.white), ),
                  ),
                  Text(artists, style: const TextStyle(color: Colors.white)),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("0", style: const TextStyle(color: Colors.blueGrey, fontSize: 10),),
                      Expanded(
                        child: Slider(
                          value: _sliderValue,
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value;
                            });
                          }
                        ),
                      ),
                      Text("0", style: const TextStyle(color: Colors.blueGrey, fontSize: 10),),
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                            child: Text("Music queue", style: TextStyle(color: Colors.white),),
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
        backgroundColor: const Color(0xFFFF86C9),
        foregroundColor: const Color(0xFF02203A),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchMusic()));
        },
        child: const Icon(Icons.add, size: 30,),
      ),
    );
  }
}