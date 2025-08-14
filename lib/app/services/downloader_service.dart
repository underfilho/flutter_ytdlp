import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';

class DownloaderService {
  static final instance = DownloaderService._();
  DownloaderService._();

  final _channel = MethodChannel('dlp_downloader');

  Future<DownloaderService> init() async {
    await _channel.invokeMethod('init');
    return this;
  }

  Future<VideoInfo> getVideoInfo(String url) async {
    var result = await _channel.invokeMethod('getVideoInfo', {'url': url});
    final json = jsonDecode(result);
    return VideoInfo.fromJson(json);
  }

  Future<String> downloadVideo(String url) async {
    var result = await _channel.invokeMethod<String>('download', {'url': url});
    if (result == null) throw Exception();

    return result;
  }

  Future<String> downloadAudio(String url) async {
    var result =
        await _channel.invokeMethod<String>('downloadAudio', {'url': url});
    if (result == null) throw Exception();

    return result;
  }
}
