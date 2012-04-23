#!/bin/sh

# Size of you bar at the bottom of the screen.
SPACE_BOTTOM=22

set_on_top()
{
  wmctrl -r :ACTIVE: -b add,above
}

unset_on_top()
{
  wmctrl -r :ACTIVE: -b remove,above
}

WIDTH=`xdpyinfo | awk '/dimensions:/ {print $2}' | cut -f1 -d'x'`
HEIGHT=`xdpyinfo | grep dimensions | sed 's/.*dimensions[^x]*x\([^ ]*\).*$/\1/'`

wmctrl -r :ACTIVE: -b remove,maximized_horz,fullscreen

# Some commands are duplicated, because sometimes I need to repeat the
# command. No idea why.

# put active window on left side
if [ "$1" = "left" ]; then
  WDT=$(($WIDTH/2))
  unset_on_top
  wmctrl -r :ACTIVE: -b add,maximized_vert
  wmctrl -r :ACTIVE: -e 0,0,0,$WDT,-1
  wmctrl -r :ACTIVE: -b add,maximized_vert
  wmctrl -r :ACTIVE: -e 0,0,0,$WDT,-1
fi

# put active window on right side
if [ "$1" = "right" ]; then
  WDT=$(($WIDTH/2))
  unset_on_top
  wmctrl -r :ACTIVE: -b add,maximized_vert 
  wmctrl -r :ACTIVE: -e 0,$WDT,0,$WDT,-1  
  wmctrl -r :ACTIVE: -b add,maximized_vert 
  wmctrl -r :ACTIVE: -e 0,$WDT,0,$WDT,-1  
fi

# put active window at the bottom of the screen (good for terminals)
if [ "$1" = "down" ]; then
  H=$(($HEIGHT/4))
  wmctrl -r :ACTIVE: -b add,maximized_horz
  wmctrl -r :ACTIVE: -e 0,0,$(($HEIGHT-$SPACE_BOTTOM-$H)),$WIDTH,$H
  wmctrl -r :ACTIVE: -b add,maximized_horz
  wmctrl -r :ACTIVE: -e 0,0,$(($HEIGHT-$SPACE_BOTTOM-$H)),$WIDTH,$H
  set_on_top
fi

# put active window at the center of the screen
if [ "$1" = "up" ]; then
  DH=$(($HEIGHT/8))
  DW=$(($WIDTH/8))
  wmctrl -r :ACTIVE: -e 0,$DW,$DH,$(($WIDTH-2*$DW)),$(($HEIGHT-2*$DH))
  wmctrl -r :ACTIVE: -e 0,$DW,$DH,$(($WIDTH-2*$DW)),$(($HEIGHT-2*$DH))
  unset_on_top
fi

# toggle "window always on top"
if [ "$1" = "atop" ]; then
  wmctrl -r :ACTIVE: -b toggle,above
fi

