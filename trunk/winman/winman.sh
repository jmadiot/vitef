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
SBOT=20
SLFT=0
SRGT=0
# size of the top+bottom borders of your windows
# (useful only for (up/low)(left/right))
SBRD=18

debug()        { echo "$1" | tee -a /tmp/winmanlog; }
set_on_top()   { wmctrl -r :ACTIVE: -b add,above;    }
unset_on_top() { wmctrl -r :ACTIVE: -b remove,above; }
fullscreen()   { wmctrl -r :ACTIVE: -b toggle,fullscreen; }

W=`xdpyinfo | awk '/dimensions:/ {print $2}' | cut -f1 -d'x'`
H=`xdpyinfo | grep dimensions | sed 's/.*dimensions[^x]*x\([^ ]*\).*$/\1/'`

# default width and heighth given the available info
DWDT=$(($W-$SLFT-$SRGT))
DHGT=$(($H-$STOP-$SBOT-$SBRD))

#wmctrl -r :ACTIVE: -b remove,maximized_horz
#wmctrl -r :ACTIVE: -b remove,maximized_vert
#wmctrl -r :ACTIVE: -b remove,fullscreen


## Getting informations about the window
win_id=$(xdotool getactivewindow)
win_x=$(xdotool getwindowgeometry $win_id | grep Position | grep -o [0-9]* | sed -n 1p)
win_y=$(xdotool getwindowgeometry $win_id | grep Position | grep -o [0-9]* | sed -n 2p)
win_w=$(xdotool getwindowgeometry $win_id | grep Geometry | grep -o [0-9]* | sed -n 1p)
win_h=$(xdotool getwindowgeometry $win_id | grep Geometry | grep -o [0-9]* | sed -n 2p)


## one-dimensional primitives

xsame() {
  dist="$((($win_x-$LFT)*($win_x-$LFT)+($win_w-$WDT)*($win_w-$WDT)))"
  debug "wid=$win_id dist=$dist : $win_x==$LFT ∧ $win_w==$WDT"
  if [ "$dist" -lt "10" ]; then yfill; fi
}

ysame() {
  dist="$((($win_y-$TOP)*($win_y-$TOP)+($win_h-$HGT)*($win_h-$HGT)))"
  debug "wid=$win_id dist=$dist : $win_y==$TOP ∧ $win_h==$HGT"
  if [ "$dist" -lt "10" ]; then xfill; fi
}

xleft() {
  LFT=$(($SLFT))
  WDT=$(($DWDT/2))
  wmctrl -r :ACTIVE: -e 1,$LFT,$win_y,$WDT,$win_h
  xsame
}

xright() {
  WDT=$(($DWDT/2))
  HGT=$((($DHGT-$SBRD)/2))
  LFT=$(($WDT+$SLFT))
  wmctrl -r :ACTIVE: -e 0,$LFT,$win_y,$WDT,$win_h
  xsame
}

xfill() {
  wmctrl -r :ACTIVE: -e 0,$SLFT,$win_y,$DWDT,$win_h
}

yup() {
  TOP=$STOP
  HGT=$((($DHGT-$SBRD)/2))
  wmctrl -r :ACTIVE: -e 0,$win_x,$TOP,$win_w,$HGT
  ysame
}

ydown() {
  HGT=$((($DHGT-$SBRD)/2))
  TOP=$(($HGT+$STOP+$SBRD))
  wmctrl -r :ACTIVE: -e 0,$win_x,$TOP,$win_w,$HGT
  ysame
}

yfill() {
  wmctrl -r :ACTIVE: -e 0,$win_x,$STOP,$win_w,$DHGT
}

center() {
  DH=$(($DHGT/8))
  DW=$(($DWDT/8))
  PADL=$(($SLFT+$DW))
  PADT=$(($TOP+$DH))
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$(($DWDT-2*$DW)),$(($DHGT-2*$DH))
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$(($DWDT-2*$DW)),$(($DHGT-2*$DH))
  unset_on_top
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
  fullscreen) wmctrl -r :ACTIVE: -b toggle,fullscreen;;
  *)          debug "unknown command: [$command]"
esac

#rm -f "$lockfile"
