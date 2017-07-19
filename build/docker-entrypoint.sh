#!/bin/bash

# start the calibreserver with
# the help of environment variables

# set the cli parameters
CLI_PARAM=" --port=80 --auto-reload"

# set path to userdb - have a look at:
# https://manual.calibre-ebook.com/server.html#managing-user-accounts-from-the-command-line-only
[ -n "${USERDB}" ] && CLI_PARAM="${CLI_PARAM} --enable-auth --userdb=${USERDB}"

# if the URL_PREFIX is set set it
[ -n "${PREFIX_URL}" ] && CLI_PARAM="${CLI_PARAM} --url-prefix=${PREFIX_URL}"

# start the calibre server
echo Starting calibre server with this cli parameters:
echo $CLI_PARAM
exec /usr/bin/calibre-server $CLI_PARAM ${LIBRARY_PATH}