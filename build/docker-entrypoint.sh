#!/bin/bash

##
# FUNCTIONS
## 

function load_secret {
    # function checks if specified environment variable contains the file path to a docker secret
    # if so it overwrite the value with the file contents

    # first parameter is the environment variable name 
    name=${1}
    # second parameter is the value of the environment variable
    value=${2}

    # now check if the value equals a file in the container
    if [ -f "${value}" ]; then
        export ${name}=$(cat "${value}")
    fi
}

function log {
    echo "$(date) docker-entrypoint.sh - ${@}"
}

function _term {
    # check for given parameters - first parameter = exit value
    retval=${1}
    [ -z ${retval} ] && retval=0
    log "received sigterm. aborting."
    log "send sigterm to calibre ${CALIBRE_PID}"
    kill -TERM ${CALIBRE_PID} 2>/dev/null

    if [ -n "${WATCH_PID}" ]; then
        log "send sigterm to watch script ${WATCH_PID}"
        kill -TERM ${WATCH_PID} 2>/dev/null
    fi

    log "all prcoesses stopped. bye"
    exit ${retval}
}

##
# TRAP
##

trap _term SIGTERM

##
# VARIABLES
##

# set the default parameters
CLI_PARAM=" --port=8080 --pidfile=/tmp/calibre.pid --daemonize --log=/dev/stdout"

# load values - either from env or from specified file (for docker secrets)
load_secret LIBRARY_PATH ${LIBRARY_PATH}
load_secret USERDB ${USERDB}
load_secret PREFIX_URL ${PREFIX_URL}
load_secret WATCH_PATH ${WATCH_PATH}
load_secret INTERVAL ${INTERVAL}
load_secret LIBRARY_ID ${LIBRARY_ID}
load_secret ONEBOOKPERDIR ${ONEBOOKPERDIR}

# make sure unprivileged users can write to stdout
# https://github.com/DE-IBH/bird-lg-docker/commit/7a0f5cc0d444b1f3a17010997a1080b4de1b44ca
chmod o+w /dev/stdout

# set permissions for the library, userdb and watch path
chown -R ${UID}:${GID} /.config
chown -R ${UID}:${GID} ${LIBRARY_PATH}
[ -n "${USERDB}" ] && chown -R ${UID}:${GID} ${USERDB}
[ -n "${WATCH_PATH}" ] && chown -R ${UID}:${GID} ${WATCH_PATH}

# set path to userdb - have a look at:
# https://manual.calibre-ebook.com/server.html#managing-user-accounts-from-the-command-line-only
[ -n "${USERDB}" ] && CLI_PARAM="${CLI_PARAM} --enable-auth --userdb=${USERDB}"

# if the URL_PREFIX is set set it
[ -n "${PREFIX_URL}" ] && CLI_PARAM="${CLI_PARAM} --url-prefix=${PREFIX_URL}"

# if the watch path is set we need to add some config and run the watch.sh script
if [ -n "${WATCH_PATH}" ]; then
    log "watch directory is set. preparing for watch.sh run"

    # enable local write for the calibre server
    CLI_PARAM="${CLI_PARAM} --enable-local-write"
    
    # check if interval is set. if not set it to 60 sec
    [ -z "${INTERVAL}" ] && INTERVAL=60
    # check if the library id is set - if not set it to the basename of the library_path
    [ -z "${LIBRARY_ID}" ] && LIBRARY_ID=$(basename ${LIBRARY_PATH})

    log "execute watch.sh"
    ONEBOOKPERDIR=${ONEBOOKPERDIR} WATCH_PATH=${WATCH_PATH} LIBRARY_ID=${LIBRARY_ID} INTERVAL=${INTERVAL} \
        gosu ${UID}:${GID} /watch.sh &

    # get the pid of the watch.sh process
    WATCH_PID=$!
    log "watch.sh started with PID ${WATCH_PID}"
fi

# start the calibre server
log "Starting calibre server with this cli parameters: $CLI_PARAM"
gosu ${UID}:${GID} /usr/bin/calibre-server $CLI_PARAM ${LIBRARY_PATH}

# get the calibre pid
if [ ! -f /tmp/calibre.pid ]; then
    log "calibre pid file not found. aborting"
    _term 1
fi
CALIBRE_PID=$(cat /tmp/calibre.pid)
log "calibre server running with pid ${CALIBRE_PID}"


while true
do
    # now we just wait until we receive a sigterm
    sleep 3 &    # This script is not really doing anything.
    wait $!
done

