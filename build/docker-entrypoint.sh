#!/bin/bash

# start the calibreserver with
# the help of environment variables

# set the cli parameters
CLI_PARAM=" --with-library ${LIBRARY_PATH} --auto-reload --max-cover ${MAX_COVER} --port 80 --develop -t 120"

# if username and password are set start
# the calibre server password protected
if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
  CLI_PARAM="${CLI_PARAM} --username ${USER} --password ${PASSWORD}"
fi

# if the URL_PREFIX is set set it
[ -n "$PREFIX_URL" ] && CLI_PARAM="${CLI_PARAM} --url-prefix ${PREFIX_URL}"

# start the calibre server
echo Starting calibre server with this cli parameters:
echo $CLI_PARAM
exec /usr/bin/calibre-server $CLI_PARAM