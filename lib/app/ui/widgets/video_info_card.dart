import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';

class VideoInfoCard extends StatelessWidget {
  final VideoInfo info;

  const VideoInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            info.thumbnailUrl,
            height: 85,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.title,
                style: TextStyle(color: AppColors.primaryTextColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  info.formattedDuration,
                  style: TextStyle(
                      color: AppColors.primaryTextColor, fontSize: 10),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
