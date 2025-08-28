import 'package:flutter_ytdlp/app/core/base/base_store.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/store/downloader_state.dart';

class DownloaderStore extends BaseStore<DownloaderState> {
  final DownloaderService _service;
  DownloaderStore(this._service) : super(DownloaderState.initial());

  void download(String url, DownloadType type) {
    emit(DownloaderState.downloading(0));

    _service.download(url, type).listen((chunk) {
      if (chunk.isComplete) return emit(DownloaderState.done(chunk.filePath));
      emit(DownloaderState.downloading(chunk.percentage));
    });
  }

  void reset() => emit(DownloaderState.initial());
}
