package com.ander.yt_dlp

import android.content.Context
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
}