#!/usr/bin/python
# Startup Empathy with a custom status setting.
# Run with no parameters for usage.
#
# Empathy does not current support a default status (or presence) setting.
# Bug: https://bugs.launchpad.net/ubuntu/+source/empathy/+bug/386000
#
# Inspired by this question: http://askubuntu.com/q/40842
#
# Add to Startup Applications like this:
#   Name:     Custom -- Start Empathy Busy
#   Command:  /usr/bin/python /path/to/empathy_set_status.py dnd
#   Comment:  Start empathy and set status to busy (do no disturb).
#
# Requires: python-dbus python-notify
#
# Licence:  GNU General Public License v3 (or any later version)
# Based on code from Kupfer: http://live.gnome.org/Kupfer

import os
import subprocess
import sys
import time

import dbus 
import pynotify as pn

# it takes a long time before empathy is willing to accept statuses
EMPATHY_STARTUP_SECONDS = 20

def show_usage():
    print "\nUsage:"
    print sys.argv[0], "|".join(_STATUSES.keys())

def start_empathy():
    subprocess.Popen(["/usr/bin/empathy", "--start-hidden"])

def set_status_from_arg():
    try:
        status = sys.argv[1]
        activate(status)
        notify_set_status(status)
    except IndexError:
        print "Missing required parameter."
        show_usage()
    except ValueError as err:
        print err
        show_usage()

def notify_set_status(status):
    success = pn.init("icon-summary-body")
    if not success:
        raise Error()

    # I like this icon, even if it's not relevant
    icon = 'notification-keyboard-brightness-low'
    pn.Notification("Empathy", "Tried to set status to "+ status, icon).show()

def main():
    start_empathy()
    time.sleep(EMPATHY_STARTUP_SECONDS)   # give empathy some time to start up
    set_status_from_arg()


def _(text):
    return text

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# All code below was derived from https://github.com/engla/kupfer/blob/master/kupfer/plugin/empathy.py
ACCOUNTMANAGER_PATH = "/org/freedesktop/Telepathy/AccountManager"
ACCOUNTMANAGER_IFACE = "org.freedesktop.Telepathy.AccountManager"
ACCOUNT_IFACE = "org.freedesktop.Telepathy.Account"
CHANNEL_GROUP_IFACE = "org.freedesktop.Telepathy.Channel.Interface.Group"
CONTACT_IFACE = "org.freedesktop.Telepathy.Connection.Interface.Contacts"
SIMPLE_PRESENCE_IFACE = "org.freedesktop.Telepathy.Connection.Interface.SimplePresence"
DBUS_PROPS_IFACE = "org.freedesktop.DBus.Properties"
CHANNELDISPATCHER_IFACE = "org.freedesktop.Telepathy.ChannelDispatcher"
CHANNELDISPATCHER_PATH = "/org/freedesktop/Telepathy/ChannelDispatcher"
CHANNEL_TYPE = "org.freedesktop.Telepathy.Channel.ChannelType"
CHANNEL_TYPE_TEXT = "org.freedesktop.Telepathy.Channel.Type.Text"
CHANNEL_TARGETHANDLE = "org.freedesktop.Telepathy.Channel.TargetHandle"
CHANNEL_TARGETHANDLETYPE = "org.freedesktop.Telepathy.Channel.TargetHandleType"
EMPATHY_CLIENT_IFACE = "org.freedesktop.Telepathy.Client.Empathy"

EMPATHY_ACCOUNT_KEY = "EMPATHY_ACCOUNT"
EMPATHY_CONTACT_ID = "EMPATHY_CONTACT_ID"

_STATUSES = {
    'available':    _('Available'),
    'away':         _('Away'),
    'dnd':          _('Busy'),
    'xa':           _('Not Available'),
    'hidden':       _('Invisible'),
    'offline':      _('Offline')
}

_ATTRIBUTES = {
    'alias':          'org.freedesktop.Telepathy.Connection.Interface.Aliasing/alias',
    'presence':       'org.freedesktop.Telepathy.Connection.Interface.SimplePresence/presence',
    'contact_caps':   'org.freedesktop.Telepathy.Connection.Interface.ContactCapabilities.DRAFT/caps',
    'jid':            'org.freedesktop.Telepathy.Connection/contact-id',
    'caps':           'org.freedesktop.Telepathy.Connection.Interface.Capabilities/caps',
}
def _create_dbus_connection():
        sbus = dbus.SessionBus()
        proxy_obj = sbus.get_object(ACCOUNTMANAGER_IFACE, ACCOUNTMANAGER_PATH)
        dbus_iface = dbus.Interface(proxy_obj, DBUS_PROPS_IFACE)
        return dbus_iface

def activate(status):
    if status not in _STATUSES.keys():
        raise ValueError("Invalid status: "+ status)

    bus = dbus.SessionBus()
    interface = _create_dbus_connection()
    for valid_account in interface.Get(ACCOUNTMANAGER_IFACE, "ValidAccounts"):
        account = bus.get_object(ACCOUNTMANAGER_IFACE, valid_account)
        connection_status = account.Get(ACCOUNT_IFACE, "ConnectionStatus")
        if connection_status != 0:
            continue

        if status == "offline":
            false = dbus.Boolean(0, variant_level=1)
            account.Set(ACCOUNT_IFACE, "Enabled", false)
        else:
            connection_path = account.Get(ACCOUNT_IFACE, "Connection")
            connection_iface = connection_path.replace("/", ".")[1:]
            connection = bus.get_object(connection_iface, connection_path)
            simple_presence = dbus.Interface(connection, SIMPLE_PRESENCE_IFACE)
            simple_presence.SetPresence(status, _STATUSES.get(status))

main()
