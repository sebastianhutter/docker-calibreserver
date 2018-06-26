FROM debian:stable-slim

# install requirements
# download calibre installer
# install calibre
RUN apt-get update \
    && apt-get install -y python curl xvfb imagemagick xz-utils \
    && bash -c "curl https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c \"import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()\"" \
    && rm -rf /var/lib/apt/lists/*

# install gosu
ENV GOSU_VERSION 1.10
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && curl -L "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" -o /usr/local/bin/gosu  \
  && chmod +x  /usr/local/bin/gosu


# prepare environment
WORKDIR /
ADD build/docker-entrypoint.sh /docker-entrypoint.sh
ADD build/watch.sh /watch.sh
RUN chmod +x /docker-entrypoint.sh /watch.sh

# the default library path
ENV LIBRARY_PATH /library
# the max size for covers
ENV MAX_COVER 300x400

# run the docker entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
