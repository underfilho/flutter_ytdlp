import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/core/base/alerts.dart';
import 'package:flutter_ytdlp/app/core/base/base_store.dart';
import 'package:flutter_ytdlp/app/core/utils/utils.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/alerts/couldnt_download_alert.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/alerts/media_not_found_alert.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/store/downloader_state.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/store/downloader_store.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/store/home_state.dart';
import 'package:flutter_ytdlp/app/ui/screens/home/store/home_store.dart';
import 'package:flutter_ytdlp/app/ui/styles/colors.dart';
import 'package:flutter_ytdlp/app/ui/widgets/animated_entry.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_button.dart';
import 'package:flutter_ytdlp/app/ui/widgets/app_switch.dart';
import 'package:flutter_ytdlp/app/ui/widgets/input_text.dart';
import 'package:flutter_ytdlp/app/ui/widgets/video_info_card.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StoreProvider<HomeStore>(
          create: (context) => HomeStore(context.read<DownloaderService>()),
        ),
        StoreProvider<DownloaderStore>(
          create: (context) =>
              DownloaderStore(context.read<DownloaderService>()),
        ),
      ],
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
  DownloaderStore get downloaderStore => context.read<DownloaderStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ConsumerBuilder<HomeStore, HomeState>(
              consumer: (state) {
                if (state.isInitial) controller.text = '';
                if (state.alert != null) alertHandler(state.alert!);
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputText(
                      controller: controller,
                      focusNode: urlFocus,
                      hint: 'Insira o link do vídeo',
                      rightIcon: urlFieldIcon,
                      onChanged: (s) {
                        if (s.isEmpty) {
                          store.reset();
                          downloaderStore.reset();
                          return;
                        }

                        store.onFieldChanged(s);
                      },
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
    alert.action(() {
      if (alert is MediaNotFoundAlert)
        return showSnackbar(
            context, 'Não foi encontrado vídeo correspondente.');
      if (alert is CouldntDownloadAlert)
        return showSnackbar(context, 'Não foi possível realizar o download.');
    });
  }

  Widget buildVideoContent() {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        return ValueListenableBuilder(
          valueListenable: downloaderStore.notifier,
          builder: (context, state, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (store.state.info != null)
                  VideoInfoCard(info: store.state.info!),
                SizedBox(height: 30),
                AnimatedEntry(
                  isEntered: state.status == DownloaderStatus.initial,
                  builder: (context) => Column(
                    children: [
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
                    ],
                  ),
                ),
                SizedBox(height: 18),
                LoadingButton(
                  width: width,
                  perc: state.percentage,
                  disabled: (!store.state.downloadAudio &&
                          !store.state.downloadVideo) ||
                      store.state.isSearching,
                  text: 'Iniciar Download',
                  endText: 'Abrir arquivo',
                  onTap: () => onButtonTap(state),
                )
              ],
            );
          },
        );
      },
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

  void onButtonTap(DownloaderState state) async {
    if (state.status == DownloaderStatus.initial) {
      final type =
          store.state.downloadAudio ? DownloadType.audio : DownloadType.video;
      downloaderStore.download(store.state.info!.url, type);
    }
    if (state.status == DownloaderStatus.done) {
      await OpenFilex.open(state.path!);
      store.reset();
      downloaderStore.reset();
    }
  }
}
