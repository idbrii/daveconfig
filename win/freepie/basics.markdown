
Basics
======

Once FreePIE is installed, you can run FreePIE.exe, open or write a script, and run it. A script defines how your device is mapped to keyboard/mouse inputs. For example, this simple wiimote script will map up on the dpad to the up arrow key.

    def update():
        if wiimote[0].buttons.button_down(WiimoteButtons.DPadUp):
            keyboard.setKeyDown(Key.UpArrow)
        else:
            keyboard.setKeyUp(Key.UpArrow)
    
    if starting:
        wiimote[0].buttons.update += update

While that script is running, pressing up on the wiimote will be the same as pressing up on your keyboard.


Wiimote
=======

* Connect Wiimote via bluetooth
 * Usually this requires enabling bluetooth and pairing your wiimote (leave the password blank). Search for a tutorial for your OS.
* Load a wiimote script.
* Run script.
* The wiimote will vibrate when it's ready.

Here's an example that configures the wiimote for NES-style controls (buttons and dpad only):

    def map_wiimote_to_key(wiimote_index, wiimote_button, key):
        # Check the global wiimote object's button state and set the global
        # keyboard object's corresponding key.
        if wiimote[wiimote_index].buttons.button_down(wiimote_button):
            keyboard.setKeyDown(key)
        else:
            keyboard.setKeyUp(key)
    
    def update():
        # Sideways controls (DPad). Map each of our desired keys.
        map_wiimote_to_key(0, WiimoteButtons.DPadRight, Key.UpArrow)
        map_wiimote_to_key(0, WiimoteButtons.DPadLeft, Key.DownArrow)
        map_wiimote_to_key(0, WiimoteButtons.DPadUp, Key.LeftArrow)
        map_wiimote_to_key(0, WiimoteButtons.DPadDown, Key.RightArrow)
        # 1 button --> Z key
        map_wiimote_to_key(0, WiimoteButtons.One, Key.Z)
        # 2 button --> X key
        map_wiimote_to_key(0, WiimoteButtons.Two, Key.X)
        # - button --> Right shift key
        map_wiimote_to_key(0, WiimoteButtons.Minus, Key.RightShift)
        # + button --> Enter key
        map_wiimote_to_key(0, WiimoteButtons.Plus, Key.Return)
    
    # If we're starting up, then hook up our update function.
    if starting:
        wiimote[0].buttons.update += update

Written by [MIGUELMARTINS1987 on pastebin](http://pastebin.com/Sjs9yB3t)

After you open and run that script in FreePIE, your wiimote can be used to simulate keyboard control.


Script Basics
=============

FreePIE provides autocompletion for the variables it provides (system, keyboard, wiimote, etc).

For more information, see [[Scripting]].

TODO
====
More basics that need filling out.

* Calibration - is it handled by FreePIE?
* How do I use the watch window?
* What globals are exposed by FreePIE? Nothing comprehensive here: Scripting
* How do I debug? How do I print to the Console?

