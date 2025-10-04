# Directions
1. Build with build.sh
2. Change the device in docker-compose.yml to match whatever the rtl-sdr dongle is
3. Make sure it's on the same network as whatever service you want to connect to
4. `docker compose up -d`
5. Make sure Jellyfin has access to a file called something.m3u with these contents:
```
#EXTINF:0,(Insert Station Name Here)
http://rtl_fin:1190/crapradio
```
6. In Jellyfin, Dashboard > Live TV > Add Tuner Device > Tuner type: M3U Tuner > File or URL: /path/to/something.m3u