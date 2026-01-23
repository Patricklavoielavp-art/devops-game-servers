#!/bin/bash
steamcmd +login anonymous \
    +force_install_dir /home/gameserver/servers/fs25 \
    +app_update <ID_FS25> validate \
    +quit
