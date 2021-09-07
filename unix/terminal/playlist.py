#! /usr/bin/env python3

# Create an html playlist of mp3 files in the current directory. Useful as a
# simple solution for casting songs to a Chromecast-enabled device: open the
# page in Chrome, ..., Cast, select device.

import http.server
import os
import socketserver
import webbrowser
from pathlib import Path

html = """
<!-- html based on https://gist.github.com/guymac/1045885/08a7230f0117031c5b4facf01f2fc737ec93725e -->
<html>
<head>
    <title>Music Player</title>
    <script type="text/javascript">

    function init()
    {{
        document.addEventListener('click', function(evt) {{ if (evt.target.tagName.toLowerCase() == 'li') {{ play(evt.target); }} }}, false);
    }}

    function skip()
    {{
    }}

    function play(elem)
    {{
        var audio = document.getElementById('audio');
        audio.src = elem.textContent + '.mp3';
        audio.play();
        elem.className = 'playing';
        skip = function()
        {{
                elem.className = '';
                if (elem.nextElementSibling)
                {{
                    play(elem.nextElementSibling);
                }}
        }}
    }}
    </script>
    <style type="text/css">
        ul {{ -webkit-column-count:2;-moz-column-count:2;column-count:2; }}
        li:hover {{ text-decoration: underline; }}
        li.playing {{ font-weight: bold; }}
    </style>
</head>
<body onload="init()">
<h1>{folder_name} - Playlist</h1>
<hr/>
<audio id="audio" controls="controls" onerror="alert('Could not play MP3 audio file ' + this.src + '!');" onended="skip()">
HTML5 MP3 audio required (Chrome, Safari, IE 9?)
</audio>

<ul>
{track_list}
</ul>
</body>
</html>
"""


def _build_tracks(p):
    tracks = p.glob("*.mp3")
    return "<li>" + "</li>\n<li>".join(t.stem for t in tracks) + "</li>"


def build_html(p):
    tracks = _build_tracks(p)
    return html.format(folder_name=p.name, track_list=tracks)


def main():
    p = Path.cwd()
    page = build_html(p)
    html_name = "playlist.html"
    html_file = p / html_name
    with html_file.open("w") as f:
        f.write(page)
    print("Opening " + html_file.as_posix())
    webbrowser.open(html_file.as_posix())


if __name__ == "__main__":
    main()
