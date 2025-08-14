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
