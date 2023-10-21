import 'dart:async';

import 'package:SoundSphere/models/app_user.dart';
import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/screens/queue.dart';
import 'package:SoundSphere/widgets/popup/popup_room.dart';
import 'package:SoundSphere/widgets/popup/popup_warning_delete_room.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late Future<Music> _actualMusic;
  late Future<Music> _nextMusic;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription _roomStream;
  late final Future<AppUser> _host;
  late PlayerState _playerState;
  late Map<String, dynamic> _userPermissions;
  Duration _duration = const Duration(seconds: 0);
  Duration _position = const Duration(seconds: 0);
  bool _muted = false;
  bool _notified = true;
  bool _isPositionChanged = false;
  bool _isUpdater = false;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    _room = widget.room;
    _playerState = _audioPlayer.state;
    _userPermissions = _room.members[FirebaseAuth.instance.currentUser!.uid];

    // Async
    _actualMusic = _room.getMusic();
    _nextMusic = _room.getNextMusic();
    _host = _room.getHost();

    // permet de mettre à jour la room selon les intéractions d'autres utilisateurs
    _roomStream = Room.getCollectionRef().doc(_room.id).snapshots(includeMetadataChanges: true).listen((event) {
      if (event.data() != null && !event.metadata.hasPendingWrites && !event.metadata.isFromCache) {
        Room newRoom = event.data()!;

        if (mounted) {
          setState(() {
            _room = newRoom;
          });
        }
        if (_isFirstBuild) return;

        String updater = _room.updater;
        bool queueToActual = false;

        if (_room.action == "next_music_new") {
          _room.action = "next_music";
          queueToActual = true;
        }

         switch (_room.action) {
           case "":
             break;
           case "user_join":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater join");
             break;
           case "user_leave":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater leave");
             _isUpdater = false;
             break;
           case "play":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater resume the music");
             _play();
             if (_isUpdater) {
               _isUpdater = false;
               _room.action = "";
               _room.actualMusic["timestamp"] = DateTime.now().millisecondsSinceEpoch;
               _room.actualMusic["position"] = _position.inSeconds;
               _room.actualMusic["state"] = PlayerState.playing.toString();
               _room.update();
             }
             break;
           case "pause":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater pause the music");
             _pause();
             if (_isUpdater) {
               _isUpdater = false;
               _room.action = "";
               _room.actualMusic["timestamp"] = DateTime.now().millisecondsSinceEpoch;
               _room.actualMusic["position"] = _position.inSeconds;
               _room.actualMusic["state"] = PlayerState.paused.toString();
               _room.update();
             }
             break;
           case "next_music":
             _room.actualMusic["state"] = _playerState == PlayerState.playing ? PlayerState.playing.toString() : PlayerState.paused.toString();
             if (queueToActual) {
               if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater play the music");
               _room.actualMusic["state"] = PlayerState.playing.toString();
             } else {
               if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater skip the music");
             }
             _room.action = "";
             _room.actualMusic["position"] = 0;
             _room.actualMusic["id"] = _room.musicQueue.values.first;
             _room.musicQueue.remove(_room.musicQueue.keys.first);
             _room.actualMusic["timestamp"] = DateTime.now().millisecondsSinceEpoch;
             nextMusic();
             if (_isUpdater) {
               _room.update();
               _isUpdater = false;
             }
             break;
           case "restart_music":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater restart the music");
             _audioPlayer.seek(const Duration(seconds: 0));
             _isUpdater = false;
             break;
           case "changed_position":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater change music position");
             _audioPlayer.seek(Duration(seconds: _room.actualMusic["position"] as int));
             _isPositionChanged = false;
             _isUpdater = false;
             break;
           case "add_music":
             if (_room.actualMusic["id"].toString().isEmpty) {
               if (_room.musicQueue.isNotEmpty && _isUpdater) {
                 _room.action = "next_music_new";
                 _room.update();
               } else {
                 _isUpdater = false;
               }
             } else {
               if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater add a music in queue");
               _isUpdater = false;
             }
             break;
           case "remove_music":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater remove a music in queue");
             _isUpdater = false;
             break;
           case "change_permissions":
             if (mounted && _notified) ToastUtil.showShortInfoToast(context, "$updater change permissions");
             _userPermissions = _room.members[FirebaseAuth.instance.currentUser!.uid];
             break;
         }
       }
     }, onError: (_) {});

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
        _actualMusic = _room.getMusic();
      });
    });

    // mise à jour progress bar
    _audioPlayer.onPositionChanged.listen((Duration duration) {
      if (_isPositionChanged == false) {
        setState(() => _position = duration);
      }
    });

    // Event quand la musique est mis en pause ou resume etc...
    _audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      if (mounted) setState(() => _playerState = playerState);
    });

    // Event quand la musique se termine (hors pause ou stop par user)
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _position = const Duration(seconds: 0);
      });
      _room.actualMusic["position"] = 0;

      if (_room.musicQueue.isNotEmpty) {
        _room.actualMusic["id"] = _room.musicQueue.keys.first;
        _room.musicQueue.remove(_room.musicQueue.keys.first);
        _room.actualMusic["state"] = PlayerState.playing.toString();
        nextMusic();
      } else {
        _room.actualMusic["id"] = "";
        _room.actualMusic["state"] = PlayerState.completed.toString();
        setState(() {
          _duration = const Duration(seconds: 0);
          _actualMusic = _room.getMusic();
        });
      }

      // Seulement l'host fait l'update pour éviter des mises à jours en masse inutiles
      if (_room.host == FirebaseAuth.instance.currentUser!.uid) {
        _room.action = "";
        _room.actualMusic["timestamp"] = DateTime.now().millisecondsSinceEpoch;
        _isUpdater = true;
        _room.update();
      }
    });
  }

  // La page se ferme donc on fait leave l'utilisateur de la room
  @override
  void dispose() {
    super.dispose();
    _roomStream.cancel().whenComplete(() {
      _audioPlayer.dispose();
      _room.removeMember(FirebaseAuth.instance.currentUser!.uid).whenComplete(() {
        if (_room.members.isEmpty || FirebaseAuth.instance.currentUser!.uid == _room.host) {
          Room.getCollectionRef().doc(_room.id).delete();
        }
      });
    });
  }

  void _pause() {
    _audioPlayer.pause();
  }

  void _play() {
    if (![PlayerState.stopped, PlayerState.completed].contains(_playerState)) {
      _audioPlayer.resume();
    }
  }

  Future<void> nextMusic() async {
    Music music = await _room.getMusic();

    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    }

    await _audioPlayer.setSource(UrlSource(music.url));
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.resume();
    setState(() {
      _nextMusic = _room.getNextMusic();
    });
  }

  Future openPopupRoom() => showDialog(
    context: context,
    builder:(context)=> PopupRoom(room: _room,),
  );

  Future openPopupWarningDelete() => showDialog(
    context: context,
    builder:(context)=> const PopupWarningDeleteRoom(warningText: "If you leave the sphere as the host, it will be deleted!", fromPopup: false),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF02203A),
        leading: BackButton(onPressed: () => openPopupWarningDelete(),),
        title: Text(_room.title, style: const TextStyle(fontFamily: 'ZenDots', fontSize: 20,),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () => openPopupRoom(),
              icon: const Icon(Icons.settings),),
          )
        ],
      ),

      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future: _actualMusic,
                builder: (context, snapshot) {
                  String title = "No music in queue...";
                  String artists = "";
                  Widget cover = const Icon(Icons.music_note, size: 60);
                  if (snapshot.hasData) {
                    Music? music = snapshot.data;
                    if (music == null || music.id == null || music.id == "") {
                      title = "No music in queue...";
                      artists = "";
                    } else {
                      cover = Image.network(music.cover!);
                      title = music.title;
                      artists = music.artists!.join(", ");
                      // Permet de synchro l'utilisateur qui join la room
                      if (_isFirstBuild || _audioPlayer.state == PlayerState.stopped) {
                        if (music.url.isNotEmpty) {
                          _audioPlayer.setSourceUrl(music.url);
                          Duration songPosition = Duration(seconds: _room.actualMusic["position"] as int);
                          _audioPlayer.seek(songPosition);
                          if (_room.actualMusic["state"] == PlayerState.playing.toString()) {
                            songPosition = Duration(seconds: Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - _room.actualMusic["timestamp"] as int).inSeconds + _room.actualMusic["position"] as int);
                            if (songPosition < _duration) {
                              _audioPlayer.seek(songPosition);
                              _audioPlayer.resume();
                            }
                          }
                        }
                      }
                    }
                    _isFirstBuild = false;
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
                    artists = "";
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: TextButton(
                            style: const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero,)),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: _room.id));
                              if (mounted) ToastUtil.showShortInfoToast(context, "Code copied");
                            },
                            child: Text("Click to copy: #${_room.id}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: FutureBuilder(
                          future: _host,
                          builder: (context, snapshot) {
                            String text = snapshot.hasData ? "Hosted by ${snapshot.data!.displayName}" : snapshot.hasError ? "Error loading host" : "Loading host";
                            return Text(text, style: const TextStyle(fontSize: 16),);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 184, width: 184,
                          decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                          child: cover
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(title, style: const TextStyle(fontSize: 20), ),
                      ),
                      Text(artists),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(AppUtilities.formatedTime(timeInSecond: _position.inSeconds.toInt()), style: const TextStyle(color: Colors.blueGrey, fontSize: 10),),
                            Expanded(
                              child: Slider(
                                min: 0,
                                max: _duration.inSeconds.toDouble(),
                                value: _position.inSeconds.toDouble(),
                                onChangeStart: (value) {
                                  if (_userPermissions["player"]["change_position"]) {
                                    _isPositionChanged = true;
                                  } else if (mounted) {
                                    ToastUtil.showShortErrorToast(context, "Not permitted");
                                  }
                                },
                                onChanged: (value) {
                                  if(_isPositionChanged) {
                                    setState(() {
                                      _position = Duration(seconds: value.toInt());
                                    });
                                  }
                                },
                                onChangeEnd: (value) {
                                  if (_isPositionChanged) {
                                    _isUpdater = true;
                                    _room.action = "changed_position";
                                    _room.actualMusic["position"] = value.toInt();
                                    _room.update();
                                  }
                                },
                              ),
                            ),
                            Text(AppUtilities.formatedTime(timeInSecond: _duration.inSeconds.toInt()), style: const TextStyle(color: Colors.blueGrey, fontSize: 10),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                _muted = !_muted;
                              });
                              if (_muted) {
                                _audioPlayer.setVolume(0.0);
                              } else {
                                _audioPlayer.setVolume(1.0);
                              }
                            },
                            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up, color: const Color(0xFFFFE681),)
                          ),
                          IconButton(
                            iconSize: 27,
                            icon: const Icon(Icons.skip_previous_outlined, color: Color(0xFFFFE681)),
                            onPressed: () {
                              if(_userPermissions["player"]["restart_music"]) {
                                if (_room.actualMusic["id"] != "") {
                                  _isUpdater = true;
                                  _room.actualMusic["position"] = 0;
                                  _room.action = "restart_music";
                                  _room.update();
                                } else if (mounted) {
                                  ToastUtil.showShortErrorToast(context, "No music");
                                }
                              } else if (mounted) {
                                ToastUtil.showShortErrorToast(context, "Not permitted");
                              }
                            },
                          ),
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFF86C9),
                            radius: 27,
                            child: IconButton(
                              iconSize: 27,
                              icon: Icon(_playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow_outlined, color: const Color(0xFF02203A),),
                              onPressed: _userPermissions["player"]["pause_play_music"] ? () {
                                if (_room.actualMusic["id"] != "") {
                                  if(_playerState == PlayerState.playing) {
                                    _isUpdater = true;
                                    _room.action = "pause";
                                    _room.update();
                                  } else {
                                    _isUpdater = true;
                                    _room.action = "play";
                                    _room.update();
                                  }
                                } else if (mounted) {
                                  ToastUtil.showShortErrorToast(context, "No music");
                                }
                              } : () {
                                if (mounted) ToastUtil.showShortErrorToast(context, "Not permitted");
                              },
                            ),
                          ),
                          IconButton(
                            iconSize: 27,
                            icon: const Icon(Icons.skip_next_outlined, color: Color(0xFFFFE681)),
                            onPressed: () {
                              if (_userPermissions["player"]["next_music"]) {
                                if (_room.musicQueue.isNotEmpty) {
                                  _isUpdater = true;
                                  _room.action = "next_music";
                                  _room.update();
                                } else {
                                  if (mounted) ToastUtil.showShortErrorToast(context, "Music queue is empty");
                                }
                              } else {
                                if (mounted) ToastUtil.showShortErrorToast(context, "Not permitted");
                              }
                            },
                          ),
                          IconButton(
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                _notified = !_notified;
                              });
                            },
                            icon: Icon(_notified ? Icons.notifications_active: Icons.notifications_off, color: const Color(0xFFFFE681),)
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 2.0, color: Color(0xFF0ee6f1)),),),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text("Next Music", style : TextStyle(fontSize: 22)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future:  _nextMusic,
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
                  if (music == null || music.id == null || music.id == "") {
                    return const Padding(
                      padding: EdgeInsets.only(top : 20),
                      child: Text("Tap the button below to add a music", style: TextStyle(fontSize: 16),),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top:16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 50, width: 50,
                              decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(7.0))),
                              child: Image.network(music.cover!)),
                          Padding(
                            padding: const EdgeInsets.only(left:12),
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(music.title, style: const TextStyle(fontSize: 20), textAlign: TextAlign.left, maxLines: 1),
                                  Text(music.artists!.join(", "), style: const TextStyle(fontSize: 16), textAlign: TextAlign.left, maxLines: 1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              )
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_userPermissions["room"]["queue"]) {
            _isUpdater = true;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Queue(room: _room)))
                .whenComplete(() {
              setState(() {
                _actualMusic = _room.getMusic();
                _nextMusic = _room.getNextMusic();
              });
            });
          }
        },
        child: const Icon(Icons.format_list_bulleted),
      ),
    );
  }
}