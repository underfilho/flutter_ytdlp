import 'dart:convert';

import 'package:flutter/services.dart';

class DownloaderService {
  static final instance = DownloaderService._();
  DownloaderService._();

  final _channel = MethodChannel('dlp_downloader');

  Future<DownloaderService> init() async {
    await _channel.invokeMethod('init');
    return this;
  }

  Future<Map<String, dynamic>?> getVideoInfo(String url) async {
    var result = await _channel.invokeMethod('getVideoInfo', {'url': url});
    return jsonDecode(result);
  }

  Future<String> downloadVideo(String url, {bool mp3 = false}) async {
    var result = await _channel.invokeMethod<String>('download', {'url': url});
    if (result == null) throw Exception();

    if (mp3) result = await convertToMp3(result);
    return result;
  }

  Future<String> convertToMp3(String videoPath) async {
    final result =
        await _channel.invokeMethod('convertToMp3', {'path': videoPath});
    return result;
  }
}
