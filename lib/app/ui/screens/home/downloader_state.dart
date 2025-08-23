enum DownloaderStatus { initial, downloading, done }

class DownloaderState {
  final DownloaderStatus status;
  final double? percentage;
  final String? path;

  DownloaderState.initial()
      : status = DownloaderStatus.initial,
        percentage = null,
        path = null;

  DownloaderState.percentage(this.percentage)
      : status = DownloaderStatus.downloading,
        path = null;

  DownloaderState.done(this.path)
      : status = DownloaderStatus.done,
        percentage = 1;
}
