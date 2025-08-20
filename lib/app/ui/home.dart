import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/models/video_info.dart';
import 'package:flutter_ytdlp/app/services/debouncer.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';
import 'package:flutter_ytdlp/app/ui/widgets/animated_entry.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_button.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_switch.dart';
import 'package:flutter_ytdlp/app/ui/widgets/input_text.dart';
import 'package:flutter_ytdlp/app/ui/widgets/video_info_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();
  bool isSearching = false;
  bool isDownloading = false;
  bool downloadAudio = false;
  bool downloadVideo = false;
  VideoInfo? videoInfo;

  final urlNode = FocusNode();
  final debouncer = Debouncer<VideoInfo>(milliseconds: 300);

  @override
  void dispose() {
    debouncer.dispose();
    super.dispose();
  }

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
                InputText(
                  controller: controller,
                  focusNode: urlNode,
                  hint: 'Insira o link do vídeo',
                  rightIcon: urlFieldIcon,
                  onChanged: (url) async {
                    if (url.isEmpty) return reset();
                    if (!isValidUrl(url)) return;

                    debouncer.run(
                      () {
                        setState(() => isSearching = true);
                        return DownloaderService.instance.getVideoInfo(url);
                      },
                      (info) {
                        urlNode.unfocus();
                        setState(() {
                          isSearching = false;
                          videoInfo = info;
                        });
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedEntry(
                  isEntered: videoInfo != null,
                  builder: buildVideoContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVideoContent(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDownloading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VideoInfoCard(info: videoInfo!),
          SizedBox(height: 30),
          AppSwitch(
            onChanged: (_) {
              if (downloadVideo) return;
              setState(() => downloadAudio = !downloadAudio);
            },
            enabled: downloadAudio,
            label: 'Áudio',
          ),
          SizedBox(height: 15),
          AppSwitch(
            onChanged: (_) {
              if (downloadAudio) return;
              setState(() => downloadVideo = !downloadVideo);
            },
            enabled: downloadVideo,
            label: 'Vídeo',
          ),
          SizedBox(height: 15),
          _AlignToRight(
            child: AppButton(
              text: isDownloading ? 'Baixando...' : 'Iniciar Download',
              onTap: () async {
                setState(() => isDownloading = true);

                if (downloadAudio)
                  await DownloaderService.instance
                      .downloadAudio(controller.text);
                if (downloadVideo)
                  await DownloaderService.instance
                      .downloadVideo(controller.text);

                setState(reset);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget? get urlFieldIcon {
    if (isSearching)
      return Transform.scale(
        scale: .4,
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 7,
        ),
      );

    return null;
  }

  void reset() {
    controller.text = '';
    isDownloading = downloadAudio = downloadVideo = isSearching = false;
    videoInfo = null;
  }

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
  }
}

class _AlignToRight extends StatelessWidget {
  final Widget child;

  const _AlignToRight({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 1,
          child: child,
        ),
      ],
    );
  }
}
