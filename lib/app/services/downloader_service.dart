import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ytdlp/app/core/base/async_response.dart';
import 'package:flutter_ytdlp/app/core/base/failures.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';

class DownloaderService {
  final _channel = MethodChannel('dlp_downloader');

  Future<DownloaderService> init() async {
    await _channel.invokeMethod('init');
    return this;
  }

  AsyncResult<VideoInfo> getVideoInfo(String url) async {
    try {
      var result = await _channel.invokeMethod('getVideoInfo', {'url': url});
      final json = jsonDecode(result);
      return right(VideoInfo.fromJson(json));
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  Stream<dynamic> download(String url, DownloadType type) {
    return EventChannel('downloader_events').receiveBroadcastStream({
      'url': url,
      'onlyAudio': type == DownloadType.audio
    }).map((event) => event);
  }
}

enum DownloadType { audio, video }
