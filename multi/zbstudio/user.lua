--[[--
  Use this file to specify **User** preferences.
  Review [examples](+C:\david\apps\bigger\ZeroBrane\cfg\user-sample.lua) or
  check [online documentation](http://studio.zerobrane.com/documentation.html)
  for details.
--]]--

editor.fontname = "Fira Code"

editor.autoreload = true
-- editor.fontsize = 12 -- this is mapped to ide.config.editor.fontsize



-- use [cfg/scheme-picker.lua](+C:\david\apps\bigger\ZeroBrane\cfg\scheme-picker.lua) to pick a scheme.
styles = loadfile('cfg/tomorrow.lua')('Zenburn')
stylesoutshell = styles -- apply the same scheme to Output/Console windows
styles.auxwindow = styles.text -- apply text colors to auxiliary windows
styles.calltip = styles.text -- apply text colors to tooltips

-- VS-style breakpoint.
keymap[ID.BREAK]            = "Shift-F9"
keymap[ID.BREAKPOINTTOGGLE] = "F9"
keymap[ID.BREAKPOINTNEXT]   = ""
keymap[ID.BREAKPOINTPREV]   = ""
