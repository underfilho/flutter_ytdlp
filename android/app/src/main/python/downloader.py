import yt_dlp
import json
import os

def hook(d, callback):
    if d['status'] == 'downloading':
        if(callback):
            callback(d['_percent_str'])
    elif d['status'] == 'finished':
        if(callback):
            callback("100%")

def download(url, only_audio, callback):
    def hook(d):
        if d['status'] == 'downloading':
            callback(d['_percent_str'].strip().replace('%', ''))
        elif d['status'] == 'finished':
            callback("done")

    if only_audio:
        format = "m4a/bestaudio/best"
    else:
        format = "best"

    ydl_opts = {
        "outtmpl": "/storage/emulated/0/Download/%(title)s.%(ext)s",
        "format": format,
        "noplaylist": True,
        "progress_hooks": [hook]
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        output_path = ydl.prepare_filename(info)

    if(only_audio):
        base, ext = os.path.splitext(output_path)
        if ext == ".mp4":
            new_path = base + ".m4a"
            os.rename(output_path, new_path)
            output_path = new_path

    return output_path

def get_video_info(url):
    ydl_opts = {
        "skip_download": True,
    }
    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=False)
            map = {
                "title": info.get("title"),
                "duration": info.get("duration"),
                "thumbnail": info.get("thumbnail"),
                "url": info.get("webpage_url"),
            }

        return json.dumps(map)
    except Exception as e:
        return None