FROM linuxserver/qbittorrent:latest

ARG NORDVPN_VERSION=3.8.1

LABEL maintainer="fluffy-godzilla"

HEALTHCHECK --interval=1m --timeout=20s --start-period=1m \
  CMD /health-check.sh

RUN addgroup --system vpn && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y wget dpkg curl gnupg2 jq iptables vim iputils-ping && \
    wget -nc https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb && dpkg -i nordvpn-release_1.0.0_all.deb && \
    apt-get update && apt-get install -yqq nordvpn${NORDVPN_VERSION:+=$NORDVPN_VERSION} || sed -i "s/init)/$(ps --no-headers -o comm 1))/" /var/lib/dpkg/info/nordvpn.postinst && \
    apt-get install -yqq && apt-get clean && \
    rm -rf \
        ./nordvpn* \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# add local files
COPY root/ /
