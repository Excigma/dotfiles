# https://github.com/harry-cpp/code-nautilus/blob/8ea0ce78f3f1f7a6af5f9e9cf93fc3e70015f61e/code-nautilus.py
# Derived from VSCode Nautilus Extension


from gi.repository import Nautilus, GObject
from subprocess import call
import os

class CompressVideoExtension(GObject.GObject, Nautilus.MenuProvider):
    def compress_video(self, menu, files):
        for file in files:
            filepath = file.get_location().get_path()
            if os.path.exists(filepath):
                call(f'10mb.video "{filepath}" &', shell=True)

    def get_file_items(self, *args):
        files = args[-1]
        video_mime_types = [
            "video/mp4", "video/x-matroska", "video/quicktime",
            "video/x-msvideo", "video/x-flv", "video/mpeg", "video/webm"
        ]

        # Filter the files to only include video files
        filtered_files = [
            file for file in files
            if any(file.is_mime_type(mime) for mime in video_mime_types)
        ]

        # Only show the menu item if there is at least one video file
        if filtered_files:
            item = Nautilus.MenuItem(
                name='CompressVideo',
                label='Run 10mb.video',
                tip='Runs 10mb.video on the selected video files to compress them'
            )
            item.connect('activate', self.compress_video, filtered_files)
            return [item]

        return []
