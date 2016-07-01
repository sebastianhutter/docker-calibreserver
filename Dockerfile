FROM debian:jessie

# install requirements
# download calibre installer
# install calibre
RUN apt-get update && \
    apt-get install -y python curl xvfb imagemagick xz-utils && \
    bash -c "curl https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c \"import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()\""

# prepare environment
WORKDIR /
ADD build/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# the default library path
ENV LIBRARY_PATH /library
# the max size for covers
ENV MAX_COVER 300x400

# run the docker entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
