class VideoInfo {
  final String title;
  final int seconds;
  final String thumbnailUrl;
  final String url;

  VideoInfo({
    required this.title,
    required this.seconds,
    required this.thumbnailUrl,
    required this.url,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      title: json['title'],
      seconds: json['duration'],
      thumbnailUrl: json['thumbnail'],
      url: json['url'],
    );
  }

  String get formattedDuration {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secs.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
