# docker-qbittorrent-nordvpn
Combines latest linuxserver/qbittorrent with nordvpn


# Use docker compose to deploy
```
  qbittorrent-nordvpn:
        image: wizz752/qbittorrent-nordvpn
        container_name: qbittorrent-nordvpn
        restart: unless-stopped
        cap_add:
          - NET_ADMIN                       # Required
          - SYS_MODULE                      # Required for TECHNOLOGY=NordLynx
        devices:
          - /dev/net/tun                    # Required
        ports:
          - 8090:8090
          - 6882:6881
          - 6882:6881/udp
        volumes:
          - /media/config:/config
          - /media/torrents:/torrents
          - /media/downloads:/downloads
        environment:
          - TZ=US/Eastern
          - PGID=1000
          - PUID=1000
          - WEBUI_PORT=8090
          - USER=USERNAME                   # Required
          - PASS=PASSWORD                   # Required
          - TECHNOLOGY=NordLynx
          - CONNECT=Canada
```
