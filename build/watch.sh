#!/bin/bash

##
# FUNCTIONS
## 


function log {
    echo "$(date) watch.sh - ${@}"
}

##
# VARIABLES
##

echo ${LIBRARY_ID}

# set the cli to execute
LIBRARY="http://127.0.0.1/#${LIBRARY_ID}"
CLI="/usr/bin/calibredb add --recurse --with-library=${LIBRARY} ${WATCH_PATH}"

# set trap for signales
trap "{ log 'received  signal. stopping'; exit 1; }" SIGHUP SIGINT SIGTERM

log "start calibre watcher - watching dir '${WATCH_PATH}', adding books to '${LIBRARY}'"
while true
do
    # lets put the sleep into the background and wait until it has finished
    # https://stackoverflow.com/questions/27694818/interrupt-sleep-in-bash-with-a-signal-trap
    sleep ${INTERVAL} &    # This script is not really doing anything.
    wait $!
    log "execute 'calibredb add'"
    ${CLI}
done