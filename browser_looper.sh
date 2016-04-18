#!/bin/bash

#
# Script by Robert Focke
# robert_focke@yahoo.com
#
# This script will cycle through the URLs in the URLs array.
# The default browser is chromium, but this can be changed by modifying
# the OPEN_URL function accordingly.
#

# Array containing the URLs to be cycled through, URLs should be between ''
URLs=(
  'http://www.google.com'
  'http://www.yahoo.com'
)

# set this variable to the number of times you want to loop, 0 for infinite
repetitions=0

# these variables represent the number of seconds each URL will be displayed for
default_sleep=60
long_sleep=180

# every multiple of long in the URL array will be displayed longer, 0 = all displayed equally
long=0


function OPEN_URL() {
    chromium-browser --no-first-run --noerrdialogs --kiosk $1 &
    sleep $2 &
    killall chromium-browser &
}


# check if loop should be finite or infinite
if [ $repetitions -eq 0 ]
then
    # infinite loop section
    counter=1
    while true
    do
        for URL in "${URLs[@]}"
        do
            # check if some URLs should be displayed longer
            if [ $long -ne 0 ]
            then
              if [ $(($counter % $long)) -eq 0 ]
              then
                  OPEN_URL $URL $long_sleep
              else
                  OPEN_URL $URL $default_sleep
              fi
            else
              OPEN_URL $URL $default_sleep
            fi
        done
    done
else
    # terminating loop section
    counter=0
    while [ $counter -lt $repetitions ]
    do
        for URL in "${URLs[@]}"
        do
          # check if some URLs should be displayed longer
          if [ $long -ne 0 ]
          then
            if [ $(($counter % $long)) -eq 0 ]
            then
                OPEN_URL $URL $long_sleep
            else
                OPEN_URL $URL $default_sleep
            fi
          else
            OPEN_URL $URL $default_sleep
          fi
        done
    done
fi

exit
