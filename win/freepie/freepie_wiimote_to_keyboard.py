# This is a script for FreePIE (http://andersmalmgren.github.io/FreePIE/)
# Source: http://pastebin.com/Sjs9yB3t
# It maps buttons on WiimoteMap 0 to keys on the keyboard
# Hopefully, this will help people having trouble making a simple "WiimoteMap to Keyboard" script
# Released under public domain.

if __name__ == '__main__':
    """Mock out the FreePIE globals."""
    class Listener():
        def __iadd__(self, other):
            return self
    class Buttons():
        update = Listener()
        def button_down(self, button):
            return False
    class Mote():
        buttons = Buttons()
    starting = True
    m = Mote()
    wiimote = [m,m,m,m]
    #wiimote = [Mote(), Mote(), Mote(), Mote()]
    class WiimoteButtons():
        DPadRight = 0
        DPadLeft = 0
        DPadUp = 0
        DPadDown = 0
        One = 0
        Two = 0
        Minus = 0
        Plus = 0
    class Key():
        pass

class WiimoteMap(object):
    """Represents a wiimote and its mappings."""

    wii_buttons = [
        WiimoteButtons.DPadRight
        , WiimoteButtons.DPadLeft
        , WiimoteButtons.DPadUp
        , WiimoteButtons.DPadDown
        , WiimoteButtons.One
        , WiimoteButtons.Two
        , WiimoteButtons.A
        , WiimoteButtons.B
        , WiimoteButtons.Minus
        , WiimoteButtons.Plus
    ]

    def __init__(self, number, key_buttons):
        """
        :number: The id for this wiimote.
        :key_buttons: Map of the wii to keyboard.

        """
        self._number = number
        self._key_buttons = key_buttons

    def update(self):
        for wii, key in zip(self.wii_buttons, self._key_buttons):
            self.map_wiimote_to_key(wii, key)

    def map_wiimote_to_key(self, wiimote_button, key):
        if wiimote[self._number].buttons.button_down(wiimote_button):
            keyboard.setKeyDown(key)
            print key
        else:
            keyboard.setKeyUp(key)


def get_keys_for_each_wii():
    keys_for_each_wii = []

    # Sideways controls (DPad). First wiimote is as close to face buttons as
    # possible.
    keys_for_each_wii.append(( Key.UpArrow
                              , Key.DownArrow
                              , Key.LeftArrow
                              , Key.RightArrow
                              , Key.D1
                              , Key.D2
                              , Key.A
                              , Key.B
                              , Key.Minus
                              , Key.Equals # Shift equals is plus
                             ))
    # TODO(dbriscoe): Fix X
    keys_for_each_wii.append(( Key.W
                              , Key.D
                              , Key.X
                              , Key.S
                              # 1 button
                              , Key.Z
                              # 2 button
                              , Key.X
                              # A button
                              , Key.D3
                              # B button
                              , Key.D4
                              # - button
                              , Key.Q
                              # + button
                              , Key.E
                             ))
    keys_for_each_wii.append(( Key.X
                              , Key.LeftShift
                              , Key.Semicolon
                              , Key.Apostrophe
                              # 1 button
                              , Key.R
                              # 2 button
                              , Key.T
                              # A button
                              , Key.G
                              # B button
                              , Key.Y
                              # - button
                              , Key.U
                              # + button
                              , Key.I
                             ))
    keys_for_each_wii.append(( Key.O
                              , Key.P
                              , Key.H
                              , Key.J
                              # 1 button
                              , Key.K
                              # 2 button
                              , Key.L
                              # A button
                              , Key.RightBracket
                              # B button
                              , Key.LeftBracket
                              # - button
                              , Key.Comma
                              # + button
                              , Key.Period
                             ))

    return keys_for_each_wii

if starting:
    motes = [WiimoteMap(i, keys) for i,keys in enumerate(get_keys_for_each_wii())]
    for i,mote in enumerate(motes):
        wiimote[i].buttons.update += mote.update

#http://www.mtbs3d.com/phpbb/viewtopic.php?f=139&t=18991
#def log_motionplus():
#   diagnostics.watch(wiimote[0].ahrs.yaw)
#   diagnostics.watch(wiimote[0].ahrs.pitch)
#   diagnostics.watch(wiimote[0].ahrs.roll)
#
#def simulate_mouse_pointer():
#   mouse.deltaX = filters.deadband(filters.delta(wiimote[0].ahrs.yaw), 0.1) * 10
#   mouse.deltaY = filters.deadband(-filters.delta(wiimote[0].ahrs.pitch), 0.1) * 10
#
#def log_nunchuck():
#   diagnostics.watch(wiimote[0].nunchuck.acceleration.x)
#   diagnostics.watch(wiimote[0].nunchuck.acceleration.y)
#   diagnostics.watch(wiimote[0].nunchuck.acceleration.z)
#   diagnostics.watch(wiimote[0].nunchuck.buttons.button_down(NunchuckButtons.Z))
#
#def simulate_mouse_press():
#   mouse.leftButton = wiimote[0].nunchuck.buttons.button_down(NunchuckButtons.Z)
#
#if starting:
#   system.setThreadTiming(TimingTypes.HighresSystemTimer)
#   system.threadExecutionInterval = 2
#
#   wiimote[0].motionplus.update += log_motionplus
#   wiimote[0].motionplus.update += simulate_mouse_pointer
#   wiimote[0].nunchuck.update += log_nunchuck
#   wiimote[0].nunchuck.update += simulate_mouse_press
#
#   wiimote[0].enable(WiimoteCapabilities.MotionPlus | WiimoteCapabilities.Extension)
