#! /usr/bin/env python3

# Dependencies:
#   pip install ahk keyboard

import os
import pprint as pretty

from ahk import AHK
from ahk.window import Window
import keyboard

import logging
logging.basicConfig(
    level=logging.INFO,
    filename='c:/scratch/ahk.log',
    filemode='w')

def print_doc(obj):
    for i in dir(obj):
        if i.startswith('_'):
            continue
        print(i)

ahk = AHK(executable_path=os.path.expandvars('$USERPROFILE/scoop/apps/autohotkey/current/AutoHotkeyU64.exe'))
# win = ahk.active_window  # get the active window
# print(win)
# win = ahk.win_get('slack.exe')  # by title
# win = ahk.win_get('slack.exe')  # by title
# print(win)
# win = list(ahk.windows())  # list of all windows
# print(win)
# win = ahk.Window(ahk, ahk_id='0xabc123')  # by ahk_id
# print(win)
# win = ahk.Window.from_mouse_position(ahk)  # a window under the mouse cursor
# print(win)
# win = ahk.Window.from_pid('20366')  # by process ID

# print_doc(win)

def conv(text):
    # text = text.decode('ascii')
    return text

def title_contains(title_substring):
    """Partial match a title against a substring.

    title_contains(string) -> function
    """
    title_substring = title_substring.encode('ascii')
    def f(win):
        t = conv(win.title)
        return title_substring in t
    return f

def window_class_match(expected_class):
    """Exact match a window against an AHK class.

    window_class_match(string) -> function
    """
    # AHK has byte strings and I can't manage to convert them to str, so go the
    # other way.
    expected_class = expected_class.encode('ascii')
    def f(win):
        n = conv(win.class_name)
        return expected_class in n
    return f

def exe_match(expected_name):
    """Exact match a window against an executable name.

    exe_match(string) -> function
    """
    # expected_name = expected_name.encode('ascii')
    def f(win):
        n = conv(win.process_name)
        return n == expected_name
    return f

# win = ahk.find_window(title_contains("Slack"))
# print(win.rect)
# # I don't see any way to get the number of monitors or their sizes.
# win.rect = (70, 124, 1140, 789)

# for win in ahk.windows():
#     print(f"{win.title} {win.engine} {win.id} {win.text}")


def move_and_restore(win_filter_fn, x, y, w, h):
    """Move window to x,y and resize to w,h.

    move_and_restore(string, int, int, int, int) -> None
    """
    win = ahk.find_window(win_filter_fn)
    win.restore()
    win.move(x, y, w, h)

class Monitor(object):
    def __init__(self, index, x,y, w, h):
        self.index = index
        # X is slightly off
        self.x = x - 10
        self.y = y
        self.width = w
        self.height = h

    def __str__(self):
        return "Monitor[{}] at ({},{}) dimensions ({},{})".format(self.index, self.x, self.y, self.width, self.height)


def get_monitor_layout():
    # This returns incorrect numbers. Sometimes height is 0. Positions are off.
    # Maybe because of text scaling?
    # import win32api
    # return [Monitor(index, *dimensions) for index,(h1,h2,dimensions) in enumerate(win32api.EnumDisplayMonitors())]
    return [
        Monitor(0, -2799, 785, 2811, 1619),
        Monitor(1, 1,  -11,  3862,  2182),
    ]


def organize_desktop():
    """Layout my desktop.

    organize_desktop() -> None
    """
    logging.info('organize_desktop')
    monitor = get_monitor_layout()
    # pretty.pprint([str(m) for m in monitor])
    avoid_right_monitor = len(monitor) == 2
    # Lay out windows for my three monitors with centre as the work machine.
    # Roughly in order of left-to-right appearance.
    move_and_restore(exe_match("slack.exe"), monitor[0].x + 22, monitor[0].y, 1554, monitor[0].height)
    move_and_restore(window_class_match("Vim"), monitor[1].x, monitor[1].y, monitor[1].width//2, monitor[1].height)
    # Game and log go here (but they position themselves).
    if avoid_right_monitor:
        # height values don't make sense for chrome, so we can't use monitor height
        move_and_restore(exe_match("chrome.exe"), monitor[0].x+1442, monitor[0].y, 1368, 830)
        # move_and_restore(exe_match("ubuntu.exe"), monitor[0].x+1410, monitor[0].y, 1419, monitor[0].height-50)
    else:
        move_and_restore(exe_match("chrome.exe"), monitor[2].x, monitor[2].y, 974, 1080)
        move_and_restore(exe_match("ubuntu.exe"), monitor[2].x+953, monitor[2].y, 974, 1087)


    # Tortoise has lots of windows and they all have the same ahk_exe
    # (TortoiseProc.exe) and ahk_class (#32770). We could do try to match on
    # text inside the window, but the title should be pretty consistent so use
    # that instead.
    if avoid_right_monitor:
        move_and_restore(title_contains("Working Copy - TortoiseSVN"), monitor[0].x + 1424, monitor[0].y + 916, 1395,  722)
    else:
        # Shouldn't this be here?
        # move_and_restore(title_contains("Working Copy - TortoiseSVN"), monitor[2].x, monitor[2].y + 482, 974, 605)
        move_and_restore(title_contains("Working Copy - TortoiseSVN", 5433, 482, 974, 605))

def shim(fn):
    try:
        fn()
    except Exception as e:
        raise e

logging.info('Starting...')

# suppress=True seems to work better, but prevents any shortcut with the
# windows key from working. Seems like this just stops working after some time.
keyboard.add_hotkey('windows+f12', organize_desktop, suppress=False)
keyboard.add_hotkey('windows+ctrl+f11', organize_desktop, suppress=False)

run_loop = True # False

# Wait for hotkeys to get hit.
while run_loop:
    keyboard.wait()
    logging.info('Done waiting')

if not run_loop:
    organize_desktop()

logging.info('Exiting')
