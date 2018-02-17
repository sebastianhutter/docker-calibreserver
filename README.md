# docker-calibreserver
calibre headless server.

In addition to serve a calibre library it can also watch a local directory for new ebooks
and add them.

## Usage
The containers behaviour can be influenced with the following environment variables
- LIBRARY_PATH: Path to the calibre library folder (default: '/library')
- WATCH_PATH: Folder to watch for new ebooks (default: empty)
- INTERVAL: Interval to scan the watched directory for new ebooks (default: 60)
- LIBRARY_ID: The id of the library to update (default: basename of LIBRARY_PATH)
- USERDB: path to the user database (default: empty)
- PREFIX_URL: url prefix for the webservice - necessary for reverse proxy setup (default: empty)

The listening port of the service is always TCP 80.

## Examples
Run a calibre server with with basic auth
```
docker run --name calibre -p 80:80 -e USERDB=/library/userdb -v /home/shutter/calibre:/library sebastianhutter/calibreserver
```

Run the calibre server behind a reverse proxy
```
docker run --name calibre -p 80:80 -v /home/shutter/calibre:/library -e PREFIX_URL="/calibre" sebastianhutter/calibreserver
```

Run calibre and watch the directory /watch for new books to add to the library
```
docker run --name calibre -p 80:80 -v /home/shutter/calibre:/library -v /home/shutter/newbooks:/watch -e WATCH_PATH=/watch sebastianhutter/calibreserver
```
