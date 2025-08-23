package com.ander.puredownloader

import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MainActivity: FlutterActivity() {
    private val service = DownloaderService()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dlp_downloader").setMethodCallHandler { call, result ->
            runAsyncTask(result) {
                when (call.method) {
                    "init" -> {
                        service.init(this)
                    }
                    "getVideoInfo" -> {
                        val url = call.argument<String>("url")
                        service.getVideoInfo(url!!)
                    }
                    else -> {}
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "downloader_events").setStreamHandler(object : EventChannel.StreamHandler {
            var events: EventChannel.EventSink? = null

            override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
                events = eventSink
                val args = arguments as Map<*, *>
                val url = args["url"] as String
                val onlyAudio = args["onlyAudio"] as? Boolean ?: false

                runOnUiThread {
                    service.download(url, onlyAudio, eventSink!!)
                }
            }

            override fun onCancel(arguments: Any?) {
                events = null
            }
        })
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
