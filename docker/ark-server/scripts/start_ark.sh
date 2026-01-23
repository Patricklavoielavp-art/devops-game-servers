#!/bin/bash

ARK_DIR="home/gameserver/servers/arkasa"

cd "$ARK_DIR"

./ShooterGame/Binaries/Linux/ShooterGameServer \
    "TheIsland_WP?SessionName=Saguenay_Survie?MaxPlayers=10?Listen" \
    -Port=7777 \
    -QueryPort=27015 \
    -log