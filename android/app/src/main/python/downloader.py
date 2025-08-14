import yt_dlp
import json

def download_video(url):
    ydl_opts = {
        "outtmpl": "/storage/emulated/0/Download/%(title)s.%(ext)s",
        "format": "best",
        "noplaylist": True
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        output_path = ydl.prepare_filename(info)

    return output_path

def download_audio(url):
    ydl_opts = {
        "outtmpl": "/storage/emulated/0/Download/%(title)s.%(ext)s",
        "format": "bestaudio/best",
        "noplaylist": True
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        output_path = ydl.prepare_filename(info)

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
            }

        return json.dumps(map)
    except Exception as e:
        return None