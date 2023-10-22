import 'dart:io';

import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeDownload {
  static FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<List<Music>> getMusicTrending() async {
    List<Music> resultMusics = [];
    try {
      YoutubeExplode youtubeExplode = YoutubeExplode();
      List<Video> trendingMusicVideos = await youtubeExplode.search("Partenaire Particulier");
      for (var element in trendingMusicVideos) {
        Video video = element;
        Music music = Music(id: video.id.value, duration: video.duration != null ? video.duration!.inSeconds : 0, artists: [video.author], title: video.title.replaceAll(video.author, "").replaceAll("-", "").trim(), cover: video.thumbnails.standardResUrl);
        resultMusics.add(music);
      }
      youtubeExplode.close();
    } catch (e) {
      print(e);
    }

    return resultMusics;
  }

  static Future<List<Music>> getVideosResult(String search) async {
    YoutubeExplode youtubeExplode = YoutubeExplode();
    List<Music> videosResult = [];
    try {
      List videoResultApi = await youtubeExplode.search(search);
      for (var element in videoResultApi) {
        if(element is Video) {
          Video video = element;
          if (video.duration!.inSeconds <= 480) {
            Music music = Music(id: video.id.value, duration: video.duration!.inSeconds, artists: [video.author], title: video.title.replaceAll(video.author, "").replaceAll("-", "").trim(), cover: video.thumbnails.standardResUrl);
            videosResult.add(music);
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return videosResult;
  }

  static Future<String> addMusicInDb(Music music, context) async {
    String downloadUrl = "";
    try {
      downloadUrl = await AppFirebase.musicsStorageRef.child('${music.id}.mp3').getDownloadURL();
    } catch (_) {
      downloadUrl = await downloadMusic(music.id);
      await Music.collectionRef.doc(music.id).set(music);
    }

    return downloadUrl;
  }

  static Future<String> downloadMusic(String videoId) async {
    YoutubeExplode youtubeExplode = YoutubeExplode();
    StreamManifest streamManifest = await youtubeExplode.videos.streamsClient.getManifest(videoId);
    AudioOnlyStreamInfo streamInfo = streamManifest.audioOnly.withHighestBitrate();

    String downloadPath = path.join(await _localPath, "$videoId.${streamInfo.container.name}");
    downloadPath = downloadPath.replaceAll(' ', '');
    downloadPath = downloadPath.replaceAll("'", '');
    downloadPath = downloadPath.replaceAll('"', '');

    File file = File(downloadPath);
    IOSink fileStream = file.openWrite();
    await youtubeExplode.videos.streamsClient.get(streamInfo).pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();

    /*var arguments = [];
    if (downloadPath.endsWith('.mp4')) {
      arguments = ["-i", downloadPath, downloadPath.replaceAll('.mp4', '.mp3')];
    } else if (downloadPath.endsWith('.webm')) {
      arguments = ["-i", downloadPath, downloadPath.replaceAll('.webm', '.mp3')];
    }
    await flutterFFmpeg.executeWithArguments(arguments).then((rc) => print("FFmpeg process exited with rc $rc"));

    if (downloadPath.endsWith('.webm') || downloadPath.endsWith('.mp4')) {
      file.delete();
    }*/

    var argumentsb = ["-codecs"];
    await flutterFFmpeg.executeWithArguments(argumentsb).then((rc) => print("FFmpeg process exited with rc $rc"));

    Reference musicRef = AppFirebase.musicsStorageRef.child('$videoId.mp3');
    await musicRef.putFile(file);
    youtubeExplode.close();
    try {
      return await musicRef.getDownloadURL();
    } catch (_) {
      return "";
    }
  }
}