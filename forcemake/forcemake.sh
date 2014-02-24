#!/bin/sh

# forcemake - automatically launch make
#
#   usage: forcemake [ OPTIONS ]
#
# Will launch make with OPTIONS.
# And again.
# And again.
# And again.
#
# Author: madiot at gmail dot com
# Version: v2012-03-10
#
# Requirements:
# - bash, grep & make deluxe edition
# - my computer
#
# Known bugs
# - quotes in OPTIONS are stripped. DEAL WITH IT. B-)

name="forcemake"
to_highlight="! LaTeX Error|^l\.[0-9][0-9]* |line [0-9][0-9]*|$" #just keep the |$
args=$@

# Notifications in case of error to be more reactive
use_graphical_notification="true"

# Console on top in case of error
# need wmctrl and xdotool because wmctrl can't display the active
# window's number
use_wmctrl=true

# To use with pdflatex you can add "cat /dev/null |" before to avoid
# pdflatex's annoying error handling.
mymake() {
  cat /dev/null | make -j $args
}

# User interface, with colors!
uptodatemsg() {
  echo
  echo "$name: \033[1;32mup to date\033[0m"
}

if "$use_wmctrl"; then
  win_id=$(xdotool getactivewindow)
fi


# RHHAA c'est mal foutu : 2 toggle "above" ça met la fenêtre à la 2e
# place, wtf. Bon mais c'est pas grave j'ai qu'à faire pareil avec
# "below". ET BEN NON ÇA MARCHE PAS. BORDEL.
show() {
  # notify-send -t 2000 "SHOW"
  if "$use_wmctrl"; then
    wmctrl -i -r "$win_id" -b remove,below
    wmctrl -i -r "$win_id" -b add,above
  fi
}

hide() {
  # notify-send -t 2000 "HIDE"
  if "$use_wmctrl"; then
    wmctrl -i -r "$win_id" -b remove,above
    wmctrl -i -r "$win_id" -b add,below
    #wmctrl -i -r "$win_id" -b remove,below
  fi
}

notuptodatemsg() {
  echo
  echo "$name: \033[1;29mnot up to date, I will launch make.\033[0m"
  echo
}

makeerrormsg() {
  echo
  echo "$name: \033[1;31mwrong call of make\033[0m (waiting for you to fix it)"
  echo
}

last_was_failure=1

notifyrecovery() {
  if [ "$last_was_failure" = "1" ]
  then
    last_was_failure=0
    $use_graphical_notification \
      && notify-send -t 2000 "$name:
No more failure"
      \ || :
  fi
}



failuremsg() {
  echo
  echo "$name: \033[1;31mcompilation error\033[0m (waiting for you to fix it)"
  $use_graphical_notification && notify-send -t 2000 "$name:
Compilation failure" || :
}

# Fonction used to predict if the script should move on after
# encountering an error.
# At first I thought that in case of no error, this would be less
# precise than [make -q] but it seems alright.
block_until_update()
{
  # The date of the directory seemed to be a good indicator. However,
  # recovery files are modified more often, so we use the dates of the
  # files that can be listed with ls.
  getstate() {
    # date +%s -r .
    ls | while read i; do date +%s -r "$i"; done | md5sum -t | grep -o '[0-9a-f]*'
  }
  statelastfailure=$(getstate)
  while [ "$(getstate)" = "$statelastfailure" ];
  do
    sleep 0.1
  done
}

# Main loop
already_built=0
while [ : ]
do
  make -q $args
  make_status=$?
  case "$make_status" in
    0) # up to date
      if [ "$already_built" = "0" ]
      then
        uptodatemsg
        already_built=1
      fi
      ;;
    1) # need to rebuild
      already_built=0
      (mymake || \
        (
          failuremsg
	  show
          block_until_update
	  hide
        )
      ) \
      | grep -E "$to_highlight" --color
      ;;
    2) # error in make
      makeerrormsg
      show
      block_until_update
      hide
      ;;
    *)
      echo "Strange status by make: '$make_status'"
      ;;
  esac
  sleep 0.1
done



# Old main loop
exit
already_built=0
while [ : ]
do
  if [ "$(make -q $args; echo $?)" = "0" ]
  then
    if [ "$already_built" = "0" ]
    then
      uptodatemsg
      already_built=1
    fi
  else
    already_built=0
    notuptodatemsg
    (mymake || \
      (
        failuremsg
        block_until_update
      )
    ) | grep -E "$to_highlight" --color
  fi
  sleep 0.1
done
