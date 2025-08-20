import 'package:flutter_ytdlp/app/services/downloader_service.dart';
import 'package:provider/provider.dart';

Future<List<Provider>> get appProviders async {
  final service = await DownloaderService().init();

  return [Provider<DownloaderService>.value(value: service)];
}
