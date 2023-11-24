ARG LND_VERSION
FROM lightninglabs/lnd:$LND_VERSION as build

FROM ubuntu:latest as final

# ===== LND =====
# https://github.com/lightningnetwork/lnd/blob/master/Dockerfile
COPY --from=build /bin/lncli /bin/
COPY --from=build /bin/lnd /bin/
COPY --from=build /verify-install.sh /
COPY --from=build /keys/* /keys/

# Store the SHA256 hash of the binaries that were just produced for later
# verification.
RUN sha256sum /bin/lnd /bin/lncli > /shasums.txt \
  && cat /shasums.txt

# Expose lnd ports (p2p, rpc).
EXPOSE 9735 10009

# ===== Install tor =====
RUN apt update -y \
    && apt install -y ca-certificates apt-transport-https gpg wget

# We source /etc/os-release to use $UBUNTU_CODENAME such as focal, jammy, etc.
RUN . /etc/os-release \
    && echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org ${UBUNTU_CODENAME} main" >> /etc/apt/sources.list.d/tor.list \
    echo "deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org ${UBUNTU_CODENAME} main" >> /etc/apt/sources.list.d/tor.list

RUN wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null

RUN apt update -y \
    && apt install -y tor

RUN sed -i \
    -e 's/#SocksPort 192.168.0.1:9100/SocksPort 9050/g' \
    -e 's/#ControlPort 9051/ControlPort 9051/g' \
    /etc/tor/torrc \
    && mkdir /etc/torrc.d \
    && echo "%include /etc/torrc.d" >> /etc/tor/torrc

