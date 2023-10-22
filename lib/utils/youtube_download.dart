import 'dart:io';

import 'package:SoundSphere/models/music.dart';
import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youtube_data_api/models/video.dart' as api_video;
import 'package:youtube_data_api/youtube_data_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class YoutubeDownload {
  static FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
  static YoutubeDataApi youtubeDataApi = YoutubeDataApi();

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<List<Music>> getMusicTrending() async {
    List<Music> resultMusics = [];
    List<api_video.Video> trendingMusicVideos = await youtubeDataApi.fetchTrendingMusic();
    for (var element in trendingMusicVideos) {
      api_video.Video video = element;
      Music music = Music(id: video.videoId!, duration: int.parse(video.duration!.replaceAll(":", "")), artists: [video.channelName!], title: video.title!, cover: video.thumbnails != null ? video.thumbnails![0].url! : "");
      resultMusics.add(music);
    }
    return resultMusics;
  }

  static Future<List<Music>> getVideosResult(String search) async {
    List<Music> videosResult = [];
    try {
      List videoResultApi = await youtubeDataApi.fetchSearchVideo(search, "AIzaSyDYjqk2HfLh4sDLsD0-S5u1vfcGjl3Hhhs");
      for (var element in videoResultApi) {
        print(element);
        if(element is api_video.Video) {
          api_video.Video video = element;
          if (int.parse(video.duration!.replaceAll(":", "")) <= 480) {
            Music music = Music(id: video.videoId!, duration: int.parse(video.duration!.replaceAll(":", "")), artists: [video.channelName!], title: video.title!, cover: video.thumbnails != null ? video.thumbnails![0].url ?? "" : "");
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
    String downloadUrl = await downloadMusic(music.id!);
    await Music.collectionRef.doc(music.id!).set(music);
    ToastUtil.showInfoToast(context, "infoMessage");
    return downloadUrl;
  }

  static Future<String> downloadMusic(String videoId) async {
    YoutubeExplode youtubeExplode = YoutubeExplode();
    VideoId videoIdObj = VideoId.fromString(videoId);
    StreamManifest streamManifest = await youtubeExplode.videos.streamsClient.getManifest(videoIdObj);
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

    youtubeExplode.close();

    var arguments = [];
    if (downloadPath.endsWith('.mp4')) {
      arguments = ["-i", downloadPath, downloadPath.replaceAll('.mp4', '.mp3')];
    } else if (downloadPath.endsWith('.webm')) {
      arguments = ["-i", downloadPath, downloadPath.replaceAll('.webm', '.mp3')];
    }
    await flutterFFmpeg.executeWithArguments(arguments).then((rc) => print("FFmpeg process exited with rc $rc"));

    if (downloadPath.endsWith('.webm') || downloadPath.endsWith('.mp4')) {
      file.delete();
    }

    Reference musicRef = AppFirebase.musicsStorageRef.child('$videoId.mp3');
    await musicRef.putFile(file);
    return await AppFirebase.musicsStorageRef.child('$videoId.mp3').getDownloadURL();
  }
}