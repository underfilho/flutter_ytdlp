import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/core/base/alerts.dart';
import 'package:flutter_ytdlp/app/core/utils/utils.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/alerts/couldnt_download_alert.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/alerts/media_not_found_alert.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/home_store.dart';
import 'package:flutter_ytdlp/app/ui/styles/colors.dart';
import 'package:flutter_ytdlp/app/ui/widgets/animated_entry.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_button.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_switch.dart';
import 'package:flutter_ytdlp/app/ui/widgets/input_text.dart';
import 'package:flutter_ytdlp/app/ui/widgets/video_info_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HomeStore>(
      create: (context) => HomeStore(context.read<DownloaderService>()),
      dispose: (_, store) => store.dispose(),
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomeState();
}

class _HomeState extends State<_HomePage> {
  final controller = TextEditingController();
  final urlFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    store.urlFocus = urlFocus;
  }

  HomeStore get store => context.read<HomeStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder(
              valueListenable: store.notifier,
              builder: (context, state, _) {
                if (state.isInitial) controller.text = '';
                if (state.alert != null) alertHandler(state.alert!);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputText(
                      controller: controller,
                      focusNode: urlFocus,
                      hint: 'Insira o link do vídeo',
                      rightIcon: urlFieldIcon,
                      onChanged: store.onFieldChanged,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedEntry(
                      isEntered: state.info != null,
                      builder: (_) => buildVideoContent(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void alertHandler(Alert alert) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      alert.action(() {
        if (alert is MediaNotFoundAlert && !alert.consumed)
          return showSnackbar(
              context, 'Não foi encontrado vídeo correspondente.');
        if (alert is CouldntDownloadAlert && !alert.consumed)
          return showSnackbar(context, 'Não foi possível realizar o download.');
      });
    });
  }

  Widget buildVideoContent() {
    return AbsorbPointer(
      absorbing: store.state.isDownloading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VideoInfoCard(info: store.state.info!),
          SizedBox(height: 30),
          AppSwitch(
            onChanged: (_) => store.toggleDownloadAudio(),
            enabled: store.state.downloadAudio,
            label: 'Áudio',
          ),
          SizedBox(height: 18),
          AppSwitch(
            onChanged: (_) => store.toggleDownloadVideo(),
            enabled: store.state.downloadVideo,
            label: 'Vídeo',
          ),
          SizedBox(height: 18),
          _AlignToRight(
            child: AppButton(
              disabled:
                  (!store.state.downloadAudio && !store.state.downloadVideo) ||
                      store.state.isSearching,
              text: store.state.isDownloading
                  ? 'Baixando...'
                  : 'Iniciar Download',
              onTap: store.download,
            ),
          )
        ],
      ),
    );
  }

  Widget? get urlFieldIcon {
    if (store.state.isSearching)
      return Transform.scale(
        scale: .4,
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 7,
        ),
      );

    return null;
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
