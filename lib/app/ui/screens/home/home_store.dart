import 'package:flutter_ytdlp/app/core/base/base_store.dart';
import 'package:flutter_ytdlp/app/core/utils/utils.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';
import 'package:flutter_ytdlp/app/services/debouncer.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/alerts/hide_keyboard_alert.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/home_state.dart';

class HomeStore extends BaseStore<HomeState> {
  final DownloaderService _service;
  final _debouncer = Debouncer<VideoInfo>(milliseconds: 300);

  HomeStore(this._service) : super(HomeState.initial());

  void onFieldChanged(String url) {
    if (url.isEmpty) return _reset();
    if (!isValidUrl(url)) return;

    _debouncer.run(
      () {
        emit(state.searching());
        return _service.getVideoInfo(url);
      },
      (info) {
        emit(state.videoFound(info));
        emit(state.alertUser(HideKeyboardAlert()));
      },
    );
  }

  void download() async {
    emit(state.downloading());

    await Future.wait([
      if (state.downloadAudio) _service.downloadAudio(state.info!.url),
      if (state.downloadVideo) _service.downloadVideo(state.info!.url),
    ]);

    emit(state.done());
    _reset();
  }

  void toggleDownloadAudio() => emit(state.toggleAudio());
  void toggleDownloadVideo() => emit(state.toggleVideo());

  void _reset() => emit(HomeState.initial());
}
