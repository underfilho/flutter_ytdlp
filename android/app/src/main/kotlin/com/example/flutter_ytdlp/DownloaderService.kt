package com.ander.yt_dlp

import android.content.Context
import com.arthenica.ffmpegkit.FFmpegKit
import com.chaquo.python.PyObject
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform

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

    fun downloadVideo(url: String): String {
        val result = pyObj.callAttr("download_video", url)
        return result.toString()
    }

    fun convertToMp3(path: String) {
        val command = "-i \"$path\" -vn -ar 44100 -ac 2 -b:a 192k \"${path.replace(".mp4", ".mp3")}\""
        FFmpegKit.execute(command)
    }
}