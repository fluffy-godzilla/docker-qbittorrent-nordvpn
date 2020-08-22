FROM linuxserver/qbittorrent:latest

ARG NORDVPN_VERSION
LABEL maintainer="fluff-godzilla"

#HEALTHCHECK --interval=5m --timeout=20s --start-period=1m \
#  CMD if test $( curl -m 10 -s https://api.nordvpn.com/vpn/check/full | jq -r '.["status"]' ) = "Protected" ; then exit 0; else nordvpn connect ${CONNECT} ; exit $?; fi

RUN addgroup --system vpn && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y wget dpkg curl gnupg2 jq iptables && \
    wget -nc https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb && dpkg -i nordvpn-release_1.0.0_all.deb && \
    apt-get update && apt-get install -yqq nordvpn${NORDVPN_VERSION:+=$NORDVPN_VERSION} || sed -i "s/init)/$(ps --no-headers -o comm 1))/" /var/lib/dpkg/info/nordvpn.postinst && \
    apt-get install -yqq && apt-get clean && \
    rm -rf \
        ./nordvpn* \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

#    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
#    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \

# add local files
COPY root/ /

# ports and volumes
#EXPOSE 6881 6881/udp 8080
#VOLUME /config /downloads
