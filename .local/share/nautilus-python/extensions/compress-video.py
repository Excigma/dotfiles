# https://github.com/harry-cpp/code-nautilus/blob/8ea0ce78f3f1f7a6af5f9e9cf93fc3e70015f61e/code-nautilus.py
# Derived from VSCode Nautilus Extension


from gi.repository import Nautilus, GObject
import subprocess
import os


class CompressVideoExtension(GObject.GObject, Nautilus.MenuProvider):
    def compress_video(self, menu, files):
        for file in files:
            filepath = file.get_location().get_path()
            if os.path.exists(filepath):
                subprocess.Popen(
                    f'(10mb.video -s -fit 10 "{filepath}" && notify-send --app-name="10mb.video" "Compression Complete" "{filepath} has been compressed.") &',
                    shell=True,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                )

    def get_file_items(self, *args):
        files = args[-1]
        # Filter the files to only include video files
        filtered_files = [file for file in files if "video/" in file.get_mime_type()]

        # Only show the menu item if there is at least one video file
        if filtered_files:
            item = Nautilus.MenuItem(
                name="CompressVideo",
                label="Run 10mb.video",
                tip="Runs 10mb.video on the selected video files to compress them",
            )
            item.connect("activate", self.compress_video, filtered_files)
            return [item]

        return []
