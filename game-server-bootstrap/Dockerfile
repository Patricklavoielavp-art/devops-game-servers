FROM ubuntu:latest

LABEL maintainer="DevOps Team"
LABEL decription="Game Server Container for SteamCMD"

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMCMD_DIR=/opt/steamcmd
ENV GAMESERVER_DIR=/opt/gameserver

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends\
    curl \
    wget \
    ca-certificates \
    lib32gcc1-s1 \
    lib32stdc++6 \
    libsdl2-2.0-0 \
    locales \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/gameserver gameserver

WORKDIR ${STEAMCMD_DIR}
RUN curl -sql "https//steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xzvf - && \
    chown -R gameserver:gameserver ${STEAMCMD_DIR}

WORKDIR ${GAMESERVER_DIR}
RUN chown -R gameserver:gameserver ${GAMESERVER_DIR}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
    CMD curl -f http://localhost:27015/ || exit 1

CMD ["/bin/bash"]