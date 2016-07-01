# docker-calibreserver
calibre headless server

## Usage
The containers behaviour can be influenced with the following environment variables
- LIBRARY_PATH: Path to the calibre library folder (default: '/library')
- MAX_COVER: The maximal cover size off the ebooks (default: '400x300')
- USER: username for basic auth (default: empty)
- PASSWORD: password for basic auth (default: empty)
- PREFIX_URL: url prefix for the webservice - necessary for reverse proxy setup (default: empty)

The listening port of the service is always TCP 80.

## Examples
Run a calibre server with with basic auth
```
docker run --name calibre -p 80:80 -e USER=calibre -e PASSWORD=mypass -v /home/shutter/calibre:/library sebastianhutter/calibreserver
```

Run the calibre server behind a reverse proxy 
```
docker run --name calibre -p 80:80 -e USER=calibre -e PASSWORD=mypass -v /home/shutter/calibre:/library -e URL_PREFIX="/calibre" sebastianhutter/calibreserver
```