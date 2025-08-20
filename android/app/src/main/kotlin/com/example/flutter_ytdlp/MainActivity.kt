package com.example.flutter_ytdlp

import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import com.ander.yt_dlp.DownloaderService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MainActivity: FlutterActivity() {
    private val CHANNEL = "dlp_downloader"
    private val service = DownloaderService()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            runAsyncTask(result) {
                when (call.method) {
                    "init" -> {
                        service.init(this)
                    }
                    "getVideoInfo" -> {
                        val url = call.argument<String>("url")
                        service.getVideoInfo(url!!)
                    }
                    "download" -> {
                        val url = call.argument<String>("url")
                        service.downloadVideo(url!!)
                    }
                    "downloadAudio" -> {
                        val url = call.argument<String>("url")
                        service.downloadAudio(url!!)
                    }
                    else -> {}
                }
            }
        }
    }

    private fun runAsyncTask(result: Result, task: suspend () -> Any?) {
        lifecycleScope.launch {
            try {
                val taskResult = withContext(Dispatchers.IO) {
                    task()
                }
                result.success(if (taskResult is Unit) null else taskResult)
            } catch (e: Exception) {
                result.error("NATIVE_ERROR", e.message ?: "Um erro nativo ocorreu", e.stackTraceToString())
            }
        }
    }
}
