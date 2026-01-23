#!/bin/bash
DATE=$(date + "%Y_%m-%d_%H-%M")
cp -r /home/gameserver/servers/fs25/savegame1 \
      /home/gameserver/backups/fs25/savegame1_$DATE