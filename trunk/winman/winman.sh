#!/bin/bash

#win_id=$(xdotool getactivewindow)
#lockfile=/tmp/winman-$win_id
#if [ -e "$lockfile" ]; then echo "Locked: waiting"; else echo "No lock"; fi
#while [ -e "$lockfile" ]; do sleep 0.03 ; done
#touch "$lockfile"
# Above, a lock. Most important thing is: no deadlock
# Sometimes the lock won't work, but that's ok.

# In case of error, the lock file will stay, so we should maybe check
# this out before waiting. Here is a wonderful workaround
#(sleep 1 && rm -f "$lockfile") &


# size of the bars around your screen:
# top, bottom, left, right
STOP=0
SBOT=22
SLFT=0
SRGT=0
# size of the top+bottom borders of your windows
# (useful only for (up/low)(left/right))
SBRD=0
# ça pourrait être réglé avec d'autres infos, ce truc, moi ça me fait
# des choses bizarres

sensibility=10


debug()        { echo "$1" | tee -a /tmp/winmanlog; }
set_on_top()   { wmctrl -r :ACTIVE: -b add,above;    }
unset_on_top() { wmctrl -r :ACTIVE: -b remove,above; }
fullscreen()   { wmctrl -r :ACTIVE: -b toggle,fullscreen; }

W=`xdpyinfo | awk '/dimensions:/ {print $2}' | cut -f1 -d'x'`
H=`xdpyinfo | grep dimensions | sed 's/.*dimensions[^x]*x\([^ ]*\).*$/\1/'`

# default width and height given the available info
DWDT=$(($W-$SLFT-$SRGT))
DHGT=$(($H-$STOP-$SBOT-$SBRD))

#wmctrl -r :ACTIVE: -b remove,maximized_horz
#wmctrl -r :ACTIVE: -b remove,maximized_vert
#wmctrl -r :ACTIVE: -b remove,fullscreen


## Getting informations about the window
win_id=$(xdotool getactivewindow)
# win_x=$(xdotool getwindowgeometry $win_id | grep Position | grep -o [0-9]* | sed -n 1p)
# win_y=$(xdotool getwindowgeometry $win_id | grep Position | grep -o [0-9]* | sed -n 2p)
win_w=$( xwininfo -id $win_id | grep Width | grep -o '[0-9]*')
win_h=$( xwininfo -id $win_id | grep Height | grep -o '[0-9]*')
#win_w=$(xdotool getwindowgeometry $win_id | grep Geometry | grep -o [0-9]* | sed -n 1p)
#win_h=$(xdotool getwindowgeometry $win_id | grep Geometry | grep -o [0-9]* | sed -n 2p)
win_x=$( xwininfo -id $win_id | grep Absolute.*X | grep -o '[0-9]*')
win_y=$( xwininfo -id $win_id | grep Absolute.*Y | grep -o '[0-9]*')
win_dx=$(xwininfo -id $win_id | grep Relative.*X | grep -o '[0-9]*')
win_dy=$(xwininfo -id $win_id | grep Relative.*Y | grep -o '[0-9]*')
win_x=$(($win_x-$win_dx))
win_y=$(($win_y-$win_dy))


## one-dimensional primitives

removemax() {
  wmctrl -r :ACTIVE: -b remove,maximized_horz
  wmctrl -r :ACTIVE: -b remove,maximized_vert
  wmctrl -r :ACTIVE: -b remove,fullscreen
}

xsame() {
  dist="$((($win_x-$LFT)*($win_x-$LFT)+($win_w-$WDT)*($win_w-$WDT)))"
  debug "wid=$win_id dist=$dist : $win_x==$LFT ∧ $win_w==$WDT"
  if [ "$dist" -lt "$sensibility" ]; then yfill; fi
}

ysame() {
  dist="$((($win_y-$TOP)*($win_y-$TOP)+($win_h-$HGT)*($win_h-$HGT)))"
  debug "wid=$win_id dist=$dist : $win_y==$TOP ∧ $win_h==$HGT"
  if [ "$dist" -lt "$sensibility" ]; then xfill; fi
}

xleft() {
  removemax
  LFT=$(($SLFT))
  WDT=$(($DWDT/2))
  wmctrl -r :ACTIVE: -e 1,$LFT,$win_y,$WDT,$win_h
  wmctrl -r :ACTIVE: -e 1,$LFT,$win_y,$WDT,$win_h
  xsame
}

xright() {
  removemax
  WDT=$(($DWDT/2))
  HGT=$((($DHGT-$SBRD)/2))
  LFT=$(($WDT+$SLFT))
  wmctrl -r :ACTIVE: -e 0,$LFT,$win_y,$WDT,$win_h
  xsame
}

xfill() {
  wmctrl -r :ACTIVE: -e 0,$SLFT,$win_y,$DWDT,$win_h
  wmctrl -r :ACTIVE: -b add,maximized_horz
}

yup() {
  removemax
  TOP=$STOP
  HGT=$((($DHGT-$SBRD)/2))
  wmctrl -r :ACTIVE: -e 0,$win_x,$TOP,$win_w,$HGT
  ysame
}

ydown() {
  removemax
  HGT=$((($DHGT-$SBRD)/2))
  TOP=$(($HGT+$STOP+$SBRD))
  wmctrl -r :ACTIVE: -e 0,$win_x,$TOP,$win_w,$HGT
  ysame
}

yfill() {
  wmctrl -r :ACTIVE: -e 0,$win_x,$STOP,$win_w,$DHGT
  wmctrl -r :ACTIVE: -b add,maximized_vert
}

center() {
  removemax
  DH=$(($DHGT/8))
  DW=$(($DWDT/8))
  TOP=$DH
  LFT=$DW
  WDT=$(($DWDT-2*$DW))
  HGT=$(($DHGT-2*$DH))
  PADL=$(($SLFT+$DW))
  PADT=$(($STOP+$DH))
  
  dist="$((($win_x-$LFT)*($win_x-$LFT)+($win_w-$WDT)*($win_w-$WDT)))"
  debug "wid=$win_id dist=$dist : $win_x==$LFT ∧ $win_w==$WDT"
  dist="$(($dist+($win_y-$TOP)*($win_y-$TOP)+($win_h-$HGT)*($win_h-$HGT)))"
  debug "wid=$win_id dist=$dist : $win_y==$TOP ∧ $win_h==$HGT"
  if [ "$dist" -lt "$((2*$sensibility))" ]; then
    DIV=16
    DH=$(($DHGT/$DIV))
    DW=$(($DWDT/$DIV))
    TOP=$DH
    LFT=$DW
    WDT=$(($DWDT-2*$DW))
    HGT=$(($DHGT-2*$DH))
    PADL=$(($SLFT+$DW))
    PADT=$(($STOP+$DH))    
  fi
  
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$WDT,$HGT
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$WDT,$HGT
  unset_on_top
}

lastscreen() {
  last=$(wmctrl -d | tail -n1 | grep -o ^[0-9][0-9]*)
  if [ "$last" = "" ]; then last=0; fi
  wmctrl -r :ACTIVE: -t $last
}

command="$1"
debug $command

case $command in
    left)       xleft;;
    right)      xright;;
    up)         yup;;
    down)       ydown;;
    center)     center;;
    atop)       wmctrl -r :ACTIVE: -b toggle,above;;
    lastscreen) lastscreen;;
    fullscreen) wmctrl -r :ACTIVE: -b toggle,fullscreen;;
    maximize)   wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz ;;
    *)          debug "unknown command: [$command]"
esac

#rm -f "$lockfile"
