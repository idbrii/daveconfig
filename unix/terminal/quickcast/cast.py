#! /usr/bin/env python
# -*- coding: utf-8 -*-

# Generate a simple web slideshow.
#
# Copyright (c) 2014 by Jim Lawless, David Briscoe
# See MIT/X11 license at
# http://www.mailsend-online.com/license2014.php


import SimpleHTTPServer
import SocketServer
import imghdr
import os
import socket
import string
import sys


def get_script_path(basename):
    return os.path.join(os.path.dirname(sys.argv[0]), basename)

def is_video(fname):
    root, ext = os.path.splitext(fname.lower())
    return ext in ('.mov', '.mpg', '.m4v', '.avi')

def generate_html(kind, is_matching_kind, files, delay_millis):
    fname = kind +'.html'

    files = [f for f in files if is_matching_kind(f)]

    # Build an HTML snippet that contains a JavaScript list of string-literals.
    img_list = "\"" + "\",\"".join(files) + "\""

    with open(get_script_path("template.htm"), "r") as tplfile:
        payload = tplfile.read()

    # Replace variables with the delay in milliseconds, generated list of
    # images, and media tag.
    payload = string.replace(payload, "$$interval_delay", delay_millis)
    payload = string.replace(payload, "$$file_list", img_list)
    payload = string.replace(payload, "$$tag_type", kind)
    with open(fname, "w") as indexfile:
        indexfile.write(payload)

def generate_index():
    fname = 'index.html'
    payload = """<h1><a href="img.html">images</a></h1><br/>
    <h1><a href="video.html">videos</a></h1>"""
    with open(fname, "w") as indexfile:
        indexfile.write(payload)


all_files = [f for f in os.listdir('.') if os.path.isfile(f)]
all_files.sort()

delay_millis = "10000"
generate_html('img', imghdr.what, all_files, delay_millis)
generate_html('video', is_video, all_files, delay_millis)
generate_index()


# Find a free port and serve our generated index file.
for port in range(8000, 8010):
    try:
        httpd = SocketServer.TCPServer(("", port), SimpleHTTPServer.SimpleHTTPRequestHandler)
        break
    except socket.error:
        pass

server_name = "http://localhost:{port}".format(port=port)
print server_name +" starting..."
try:
    httpd.serve_forever()
except KeyboardInterrupt:
    httpd.shutdown()
    print server_name +" stopped."

