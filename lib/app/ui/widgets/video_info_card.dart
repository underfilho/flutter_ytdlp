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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.secondaryTextColor,
          ),
          width: 85,
          height: 85,
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
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${info.seconds.toString()}sec',
                  style: TextStyle(color: AppColors.primaryTextColor),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
