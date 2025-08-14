import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/services/downloader_service.dart';

import 'app/ui/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DownloaderService.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
