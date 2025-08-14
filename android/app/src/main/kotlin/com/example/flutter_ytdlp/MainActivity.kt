package com.example.flutter_ytdlp

import com.ander.yt_dlp.DownloaderService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "dlp_downloader"
    private val service = DownloaderService()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> {
                    service.init(this)
                    result.success(null)
                }
                "getVideoInfo" -> {
                    val url = call.argument<String>("url")
                    val videoData = service.getVideoInfo(url!!)
                    result.success(videoData)
                }
                "download" -> {
                    val url = call.argument<String>("url")
                    val videoPath = service.downloadVideo(url!!)
                    result.success(videoPath)
                }
                "downloadAudio" -> {
                    val url = call.argument<String>("url")
                    val videoPath = service.downloadAudio(url!!)
                    result.success(videoPath)
                }
            }
        }
    }
}
