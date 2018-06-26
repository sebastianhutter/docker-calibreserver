#!/bin/bash

##
# FUNCTIONS
## 

function log {
    echo "$(date) watch.sh - ${@}"
}

##
# TRAP
##

trap "{ log 'received  signal. stopping'; exit 1; }" SIGHUP SIGINT SIGTERM


##
# VARIABLES
##

# set the cli to execute
LIBRARY="http://127.0.0.1:8080/#${LIBRARY_ID}"
CLI="/usr/bin/calibredb add --recurse --with-library=${LIBRARY}"
# if one book per directory var is not empty set the parameter
[ -n "${ONEBOOKPERDIR}" ] && CLI="${CLI} --one-book-per-directory"
CLI="${CLI} ${WATCH_PATH}"

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