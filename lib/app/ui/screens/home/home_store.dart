import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/core/base/async_response.dart';
import 'package:flutter_ytdlp/app/core/base/base_store.dart';
import 'package:flutter_ytdlp/app/core/utils/utils.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';
import 'package:flutter_ytdlp/app/services/debouncer.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/alerts/media_not_found_alert.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/home_state.dart';

class HomeStore extends BaseStore<HomeState> {
  final DownloaderService _service;
  HomeStore(this._service) : super(HomeState.initial());

  final _debouncer = Debouncer<VideoInfo>(milliseconds: 300);
  late final FocusNode urlFocus;

  void onFieldChanged(String url) {
    if (url.isEmpty) return _reset();
    if (!isValidUrl(url)) return;

    _debouncer.run(
      () async {
        emit(state.searching());
        final response = await _service.getVideoInfo(url);
        if (response.isRight()) return response.value;

        _reset();
        emit(state.alertUser(MediaNotFoundAlert()));
        return null;
      },
      (info) {
        urlFocus.unfocus();
        emit(state.videoFound(info));
      },
    );
  }

  void toggleDownloadAudio() {
    final downloadAudio = !state.downloadAudio;
    final downloadVideo = downloadAudio ? false : state.downloadVideo;
    emit(state.toggleSwitch(downloadAudio, downloadVideo));
  }

  void toggleDownloadVideo() {
    final downloadVideo = !state.downloadVideo;
    final downloadAudio = downloadVideo ? false : state.downloadAudio;
    emit(state.toggleSwitch(downloadAudio, downloadVideo));
  }

  void _reset() => emit(HomeState.initial());
}
