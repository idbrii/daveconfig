#!/usr/bin/osascript
-- © Copyright 2006, Red Sweater Software. All Rights Reserved.
-- Permission to copy granted for personal use only. All copies of this script
-- must retain this copyright information and all lines of comments below, up to
-- and including the line indicating "End of Red Sweater Comments". 
--
-- Any commercial distribution of this code must be licensed from the Copyright
-- owner, Red Sweater Software.
--
-- This script alters the color of the frontmost Terminal window to be something random.
--
-- End of Red Sweater Comments

-- This nasty constant might as well be a global
global kColorValueMaximum
set kColorValueMaximum to 65535
-- (kalos) Use a different maximum to keep our background dark
global kDarkColorValueMaximum
set kDarkColorValueMaximum to 5000

-- Choose a random dark color for the background
set randomRed to (random number) * kDarkColorValueMaximum
set randomGreen to (random number) * kDarkColorValueMaximum
set randomBlue to (random number) * kDarkColorValueMaximum
set myBackgroundColor to {randomRed, randomGreen, randomBlue}

-- Select appropriate text colors based on that background
set {myTextColor, myBoldColor} to my ContrastingTextColors(myBackgroundColor)

-- Now inflict them on the frontmost window
tell application "Terminal"
	set targetWindow to window 1
	set background color of targetWindow to myBackgroundColor
	set cursor color of targetWindow to myTextColor
	set normal text color of targetWindow to myTextColor
	set bold text color of targetWindow to myBoldColor
end tell

on ContrastingTextColors(myColor)
	set whiteColor to {kColorValueMaximum, kColorValueMaximum, kColorValueMaximum, kColorValueMaximum}
	set lightGreyColor to {40000, 40000, 40000, kColorValueMaximum}
	set blackColor to {0, 0, 0, kColorValueMaximum}
	set darkGreyColor to {20000, 20000, 20000, kColorValueMaximum}
	
	-- From http://www.wilsonmar.com/1colors.htm
	set myRed to (item 1 of myColor) / kColorValueMaximum
	set myGreen to (item 2 of myColor) / kColorValueMaximum
	set myBlue to (item 3 of myColor) / kColorValueMaximum
	set magicY to (0.3 * myRed) + (0.59 * myGreen) + (0.11 * myBlue)
	if (magicY < 0.5) then
		return {whiteColor, lightGreyColor}
	else
		return {blackColor, darkGreyColor}
	end if
end ContrastingTextColors
