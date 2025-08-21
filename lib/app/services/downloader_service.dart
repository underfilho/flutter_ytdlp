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

  AsyncResult<String> downloadVideo(String url) async {
    try {
      var result =
          await _channel.invokeMethod<String>('download', {'url': url});
      if (result == null) return left(UnknownFailure());
      return right(result);
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  AsyncResult<String> downloadAudio(String url) async {
    try {
      var result =
          await _channel.invokeMethod<String>('downloadAudio', {'url': url});
      if (result == null) return left(UnknownFailure());
      return right(result);
    } catch (e) {
      return left(UnknownFailure());
    }
  }
}
