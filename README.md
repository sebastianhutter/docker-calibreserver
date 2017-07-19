# docker-calibreserver
calibre headless server

## Usage
The containers behaviour can be influenced with the following environment variables
- LIBRARY_PATH: Path to the calibre library folder (default: '/library')
- USERDN: path to the user database (default: empty)
- PREFIX_URL: url prefix for the webservice - necessary for reverse proxy setup (default: empty)

The listening port of the service is always TCP 80.

## Examples
Run a calibre server with with basic auth
```
docker run --name calibre -p 80:80 -e USERDB=/library/userdb -v /home/shutter/calibre:/library sebastianhutter/calibreserver
```

Run the calibre server behind a reverse proxy
```
docker run --name calibre -p 80:80 -v /home/shutter/calibre:/library -e URL_PREFIX="/calibre" sebastianhutter/calibreserver
```