import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';

class VideoInfo extends StatelessWidget {
  const VideoInfo({super.key});

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Título do vídeo",
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
                "2:30",
                style: TextStyle(color: AppColors.primaryTextColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
