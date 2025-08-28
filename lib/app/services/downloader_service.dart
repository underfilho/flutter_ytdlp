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

  Stream<DownloadChunk> download(String url, DownloadType type) {
    final brackets = RegExp(r'\[.*?\]');

    return EventChannel('downloader_events').receiveBroadcastStream(
        {'url': url, 'onlyAudio': type == DownloadType.audio}).where((e) {
      return !brackets.hasMatch(e) || _stages.keys.any((s) => e.contains(s));
    }).map((event) {
      if (brackets.hasMatch(event)) {
        final stage = _stages.keys.firstWhere((stage) => event.contains(stage));
        return DownloadChunk(_stages[stage]!);
      }

      final perc = double.tryParse(event);
      if (perc != null) return DownloadChunk(50 + (perc / 100 * .5));

      return DownloadChunk(1, filePath: event);
    });
  }
}

class DownloadChunk {
  final double percentage;
  final String? filePath;

  DownloadChunk(this.percentage, {this.filePath});

  bool get isComplete => filePath != null;
}

enum DownloadType { audio, video }

const _stages = {
  'webpage': .1,
  'client config': .2,
  'tv player': .3,
  'ios player': .4,
  'm3u8': .5,
};
