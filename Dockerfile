FROM linuxserver/qbittorrent:latest

LABEL maintainer="fluffy-godzilla"

HEALTHCHECK --interval=1m --timeout=20s --start-period=1m \
  CMD if test $( curl -m 10 -s https://api.nordvpn.com/vpn/check/full | jq -r '.["status"]' ) = "Protected" ; then exit 0; else nordvpn connect ${CONNECT} ; status=$?; pkill -9 qbittorrent-nox ; exit $status; fi

RUN addgroup --system vpn && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y wget dpkg curl gnupg2 jq iptables vim iputils-ping && \
    wget -nc https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb && dpkg -i nordvpn-release_1.0.0_all.deb && \
    apt-get update && apt-get install -yqq nordvpn || sed -i "s/init)/$(ps --no-headers -o comm 1))/" /var/lib/dpkg/info/nordvpn.postinst && \
    apt-get install -yqq && apt-get clean && \
    rm -rf \
        ./nordvpn* \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# add local files
COPY root/ /
