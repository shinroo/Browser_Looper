#!/bin/bash

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

# Array containing the URLs to be cycled through, URLs should be between ''
URLs=(
  #de
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w76390421p78982821/'
  #at
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w99569449p103509175/'
  #dashboard
  'https://sites.google.com/a/hometogo.de/analytics-dashboard/'
  #ch
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w99573622p103478678/'
  #fr
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w94899173p98926757/'
  #dashboard
  'https://sites.google.com/a/hometogo.de/analytics-dashboard/'
  #nl
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w96410452p100559082/'
  #pl
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w95347242p99408504/'
  #dashboard
  'https://sites.google.com/a/hometogo.de/analytics-dashboard/'
  #uk
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w99535565p103509174/'
  #it
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w99824667p103742976/'
  #dashboard
  'https://sites.google.com/a/hometogo.de/analytics-dashboard/'
  #es
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w100636822p104521485/'
  #com
  'https://analytics.google.com/analytics/web/#realtime/rt-overview/a45666214w100636822p104521485/'
  #dashboard
  'https://sites.google.com/a/hometogo.de/analytics-dashboard/'
)

# Array containing the tags for the various URLS
TAGS=(
  'DE'
  'AT'
  'DASH'
  'CH'
  'FR'
  'DASH'
  'NL'
  'PL'
  'DASH'
  'UK'
  'IT'
  'DASH'
  'ES'
  'COM'
  'DASH'
)

# set this variable to the number of times you want to loop, 0 for infinite
repetitions=3

# these variables represent the number of seconds each URL will be displayed for
default_sleep=60
long_sleep=180

# every multiple of long in the URL array will be displayed longer, 0 = all displayed equally
long=0


function OPEN_URL {
    chromium-browser --no-first-run --noerrdialogs --kiosk $1 &
    sleep $2
    /usr/bin/pkill --oldest --signal TERM -f chromium-browser
}

function SQUARE {
    python main.py $1 &
}

function UNSQUARE {
  pkill -f main.py
}

# check if loop should be finite or infinite
if [ $repetitions -eq 0 ]
then
    # infinite loop section
    counter=1
    while true
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
