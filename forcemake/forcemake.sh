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
to_highlight="! LaTeX Error|^l\.[0-9]* |line [0-9]*|$" #just keep the |$
use_graphical_notification="true"

# To use with pdflatex you can add "cat /dev/null |" before to avoid
# pdflatex's annoying error handling.
mymake() {
  cat /dev/null | make -j $*
}

# User interface, with colors!
uptodatemsg() {
  echo
  echo "$name: \033[1;32mup to date\033[0m"
}

notuptodatemsg() {
  echo
  echo "$name: \033[1;29mnot up to date, I will launch make.\033[0m"
  echo
}

makeerrormsg() {
  echo
  echo "$name: \033[1;31mwrong call of make\033[0m (waiting for your fix)"
  echo
}

notifyrecovery() {
  $use_graphical_notification && notify-send -t 2000 "$name:
No more failure" || :
}

failuremsg() {
  echo
  echo "$name: \033[1;31merror\033[0m (waiting for your fix)"
  $use_graphical_notification && notify-send -t 2000 "$name:
Compilation failure" || :
}

# Fonction used to predict if the script should move on after
# encountering an error.
# At first I thought that in case of no error, this would be less
# precise than [make -q] but it seems alright.
block_until_update()
{
  # The date of the directory seems to be a good indicator
  getstate() {
    date +%s -r .
  }
  statelastfailure=$(getstate)
  while [ "$(getstate)" -eq "$statelastfailure" ];
  do
    sleep 0.1
  done
}

# Main loop
already_built=0
while [ : ]
do
  make -q $*
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
          block_until_update
        )
      ) \
      | grep -E "$to_highlight" --color
      ;;
    2) # error in make
      makeerrormsg
      block_until_update
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
  if [ "$(make -q $*; echo $?)" = "0" ]
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
