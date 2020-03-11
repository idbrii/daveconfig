#! /usr/bin/env python3

# pip install ahk
from ahk import AHK
from ahk.window import Window

def print_doc(obj):
    for i in dir(obj):
        if i.startswith('_'):
            continue
        print(i)

ahk = AHK(executable_path='C:/david/apps/AutoHotkey/AutoHotkey.exe')
win = ahk.active_window  # get the active window
# print(win)
# win = ahk.win_get('slack.exe')  # by title
# win = ahk.win_get('slack.exe')  # by title
# print(win)
# win = list(ahk.windows())  # list of all windows
# print(win)
# win = Window(ahk, ahk_id='0xabc123')  # by ahk_id
# print(win)
# win = Window.from_mouse_position(ahk)  # a window under the mouse cursor
# print(win)
# win = Window.from_pid('20366')  # by process ID

# print_doc(win)

def matches_title(title_substring):
    """Partial match a title against a substring.

    matches_title(string) -> function
    """
    def f(win):
        return title_substring in str(win.title)
    return f

win = ahk.find_window(matches_title("Slack"))
print(win.rect)
# I don't see any way to get the number of monitors or their sizes.
win.rect = (70, 124, 1140, 789)

# for win in ahk.windows():
#     print(f"{win.title} {win.engine} {win.id} {win.text}")
