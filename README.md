# What
Docker container that takes an rtl-sdr as an input and outputs an audio stream listening to a certain FM radio frequency

## Technologies used
- icecast
- ezstream
- rtl_fm

# Directions
1. Build with build.sh
2. Change the device in docker-compose.yml to match whatever the rtl-sdr dongle is
3. Make sure it's on the same network as whatever service you want to connect to
4. `docker compose up -d`
5. You now have a stream available at http://your_ip:1190/radio