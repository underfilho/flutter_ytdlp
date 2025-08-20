import 'package:equatable/equatable.dart';
import 'package:flutter_ytdlp/app/core/base/alerts.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';

enum HomeStatus { initial, searching, found, downloading, done }

class HomeState extends Equatable {
  final VideoInfo? info;
  final HomeStatus status;
  final Alert? alert;
  final bool downloadAudio;
  final bool downloadVideo;

  const HomeState._({
    required this.status,
    this.info,
    this.alert,
    this.downloadAudio = false,
    this.downloadVideo = false,
  });

  bool get isInitial => status == HomeStatus.initial;
  bool get isSearching => status == HomeStatus.searching;
  bool get isDownloading => status == HomeStatus.downloading;

  const HomeState.initial() : this._(status: HomeStatus.initial);

  HomeState searching() => _copyWith(status: HomeStatus.searching);

  HomeState alertUser(Alert alert) => _copyWith(alert: alert);

  HomeState videoFound(VideoInfo info) =>
      _copyWith(status: HomeStatus.found, info: info);

  HomeState toggleAudio() => _copyWith(downloadAudio: !downloadAudio);

  HomeState toggleVideo() => _copyWith(downloadVideo: !downloadVideo);

  HomeState downloading() => _copyWith(status: HomeStatus.downloading);

  HomeState done([Alert? successAlert]) =>
      _copyWith(status: HomeStatus.done, alert: successAlert);

  HomeState _copyWith({
    VideoInfo? info,
    HomeStatus? status,
    Alert? alert,
    bool? downloadAudio,
    bool? downloadVideo,
  }) {
    return HomeState._(
      info: info ?? this.info,
      status: status ?? this.status,
      alert: alert,
      downloadAudio: downloadAudio ?? this.downloadAudio,
      downloadVideo: downloadVideo ?? this.downloadVideo,
    );
  }

  @override
  List<Object?> get props =>
      [info, status, alert, downloadAudio, downloadVideo];
}
