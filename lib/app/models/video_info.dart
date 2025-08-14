class VideoInfo {
  final String title;
  final int seconds;
  final String thumbnailUrl;

  VideoInfo(
      {required this.title, required this.seconds, required this.thumbnailUrl});

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      title: json['title'],
      seconds: json['duration'],
      thumbnailUrl: json['thumbnail'],
    );
  }
}
