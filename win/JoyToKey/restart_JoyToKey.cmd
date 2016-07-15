:: Restart JoyToKey to force it to detect new joysticks. It doesn't
:: automatically detect newly connected gamepads, so we must do this. This
:: script is called from DS4Windows since the wireless DS4 is frequently
:: disconnected and reconnected.
@title %0
taskkill /im JoyToKey.exe
start /b %~dp0\JoyToKey.exe

