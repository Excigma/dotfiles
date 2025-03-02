# https://github.com/chr314/nautilus-copy-path/blob/14a2d2a0e54ecd6253ee84ee6a636feebce9e829/translation.py

# MIT License
#
# Copyright (c) 2019 Aslanov Christoforos
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import locale
import json
import glob
import os


class Translation:
    _translations_path = os.path.join(os.path.dirname(__file__), 'translations')
    _translations = []
    _default_translations = []

    @staticmethod
    def select_language(lang_code="auto"):
        if not lang_code or lang_code == "auto":
            default_locale = locale.getdefaultlocale()[0]
            try:
                lang = default_locale.split("_")
                lang_code = lang[0] if len(lang) else "en"
            except AttributeError:
                lang_code = "en"

        if lang_code in Translation.available_languages():
            Translation.lang_code = lang_code
        else:
            Translation.lang_code = "en"

        Translation._load_lang(Translation.lang_code)

    @staticmethod
    def _load_lang(lang_code):
        file_path = Translation._translations_path + '/' + lang_code + ".json"
        if os.path.isfile(file_path):
            with open(file_path) as json_file:
                Translation._translations = json.load(json_file)

        file_path_en = Translation._translations_path + "/en.json"
        if os.path.isfile(file_path_en):
            with open(file_path_en) as json_file:
                Translation._default_translations = json.load(json_file)

    @staticmethod
    def available_languages():
        return [os.path.splitext(os.path.basename(x))[0] for x in glob.glob(Translation._translations_path + '/*.json')]

    @staticmethod
    def t(translation):
        if not Translation._translations:
            Translation.select_language()
        if translation in Translation._translations:
            return Translation._translations[translation]
        elif translation in Translation._default_translations:
            return Translation._default_translations[translation]