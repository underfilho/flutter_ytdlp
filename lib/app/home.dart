import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/downloader_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: urlController),
              ElevatedButton(
                onPressed: () async {
                  if (urlController.text.isEmpty) return;

                  DownloaderService.instance.getVideoInfo(urlController.text);
                },
                child: Text('Baixar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
