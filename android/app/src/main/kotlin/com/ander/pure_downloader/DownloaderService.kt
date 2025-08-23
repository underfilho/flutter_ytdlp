package com.ander.puredownloader

import android.content.Context
import com.chaquo.python.PyObject
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import io.flutter.plugin.common.EventChannel

class DownloaderService {
    private lateinit var pyObj: PyObject

    fun init(context: Context) {
        if (!Python.isStarted())
            Python.start(AndroidPlatform(context))
        val py = Python.getInstance()
        pyObj = py.getModule("downloader")
    }

    fun getVideoInfo(url: String): String {
        val result = pyObj.callAttr("get_video_info", url)
        return result.toString()
    }

    fun download(
        url: String,
        onlyAudio: Boolean = false,
        progressSink: EventChannel.EventSink
    ) {
        var outputPath = ""
        val progressCallback = PyObject.fromJava { progress: String ->
            progressSink.success(progress)
        }

        try {
            outputPath = pyObj.callAttr("download", url, onlyAudio, progressCallback).toString()
            progressSink.success(outputPath)
            progressSink.endOfStream()
        } catch (e: Exception) {
            progressSink.error("DOWNLOAD_ERROR", e.message, null)
        }
    }
}
