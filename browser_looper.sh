#!/usr/bin/env bash

# initial setup
set -euo pipefail
IFS=$'\n\t'

#
# Script by Robert Focke
# robert_focke@yahoo.com
#
# This script will cycle through the URLs in the URLs array.
# The default browser is chromium, but this can be changed by modifying
# the OPEN_URL function accordingly.
#

#
# This script uses the chromium browser
# if you need to install it please use sudo apt-get install chromium-browser
# or a similar command for your os
#

#
# This script makes use of a python script developed by Emil Milanov
# download link: https://github.com/emomicrowave/top-label
# please place the main.py file in the same directory as this script
#

# Array containing the URLs to be cycled through, URLs should be between ''
URLs=(
  'http://www.google.com'
  'http://www.reddit.com'
  'http://www.4chan.org'
)

# Array containing the tags for the various URLS
TAGS=(
  'google'
  'reddit'
  '4chan'
)

# set this variable to the number of times you want to loop, 0 for infinite
repetitions=0

# these variables represent the number of seconds each URL will be displayed for
default_sleep=60
long_sleep=180

# every multiple of long in the URL array will be displayed longer, 0 = all displayed equally
long=3


function OPEN_URL {
    chromium-browser --no-first-run --noerrdialogs --kiosk $1 &
    sleep $2
    pkill --oldest --signal TERM -f chromium-browser
}

function SQUARE {
    python2 /home/pi/.config/lxsession/LXDE-pi/main.py $1 &
}

function UNSQUARE {
    pkill -f main.py
}

# check if loop should be finite or infinite
if [ $repetitions -eq 0 ]
then
    # infinite loop section
    while true
    do
        arraycounter=0
	      counter=1
        for URL in "${URLs[@]}"
        do
            # check if some URLs should be displayed longer
            if [ $long -ne 0 ]
            then
              if [ $(($counter % $long)) -eq 0 ]
              then
                  SQUARE ${TAGS[$(($arraycounter))]}
                  OPEN_URL $URL $long_sleep
                  UNSQUARE
              else
                  SQUARE ${TAGS[$(($arraycounter))]}
                  OPEN_URL $URL $default_sleep
                  UNSQUARE
              fi
            else
              SQUARE ${TAGS[$(($arraycounter))]}
              OPEN_URL $URL $default_sleep
              UNSQUARE
            fi
            arraycounter=$((arraycounter+1))
	          counter=$((counter+1))
        done
    done
else
    # terminating loop section
    counter=0
    while [ $counter -lt $repetitions ]
    do
        arraycounter=0
        for URL in "${URLs[@]}"
        do
          # check if some URLs should be displayed longer
          if [ $long -ne 0 ]
          then
            if [ $(($counter % $long)) -eq 0 ]
            then
                SQUARE ${TAGS[$(($arraycounter))]}
                OPEN_URL $URL $long_sleep
                UNSQUARE
            else
                SQUARE ${TAGS[$(($arraycounter))]}
                OPEN_URL $URL $default_sleep
                UNSQUARE
            fi
          else
            SQUARE ${TAGS[$(($arraycounter))]}
            OPEN_URL $URL $default_sleep
            UNSQUARE
          fi
          arraycounter=$((arraycounter+1))
        done
        counter=$((counter+1))
    done
fi

exit
