import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_button.dart';
import 'package:flutter_ytdlp/app/ui/widgets/video_info_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();
  var isDownloading = false;
  VideoInfo? videoInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.containerColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    hintText: "Enter your link",
                    hintStyle: TextStyle(color: AppColors.secondaryTextColor),
                  ),
                  onSubmitted: (url) async {
                    final info =
                        await DownloaderService.instance.getVideoInfo(url);
                    setState(() {
                      videoInfo = info;
                    });
                  },
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (videoInfo != null) VideoInfoCard(info: videoInfo!),
                SizedBox(
                  height: 30,
                ),
                if (videoInfo != null)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          text: isDownloading ? 'Baixando...' : 'Baixar vídeo',
                          onTap: () async {
                            setState(() {
                              isDownloading = true;
                            });
                            await DownloaderService.instance
                                .downloadVideo(controller.text);
                            setState(() {
                              isDownloading = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
