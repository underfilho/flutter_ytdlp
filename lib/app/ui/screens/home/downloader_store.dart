import 'package:flutter_ytdlp/app/core/base/base_store.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/downloader_state.dart';

class DownloaderStore extends BaseStore<DownloaderState> {
  final DownloaderService _service;
  DownloaderStore(this._service) : super(DownloaderState.initial());

  void download(String url, DownloadType type) {
    emit(DownloaderState.percentage(0));

    _service.download(url, type).listen((value) {
      final perc = double.tryParse(value);
      if (perc == null) return emit(DownloaderState.done(value));
      emit(DownloaderState.percentage(perc));
    });
  }
}
