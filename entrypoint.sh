#!/bin/bash
set -e

echo "*** Checking core.conf"
if [ ! -f /config/core.conf ]; then
    echo "   * core.conf doesn't exist. creating default core.conf"
    cp /app/core.conf /config/core.conf
    chmod -R 777 /config
    echo "$DELUGE_USER:$DELUGE_PASSWORD:10" >> /config/auth
fi

if [ -z $DISABLE_CREATE_DEFAULT_FOLDERS]; then
    echo "*** Creating default download directories"
    mkdir -p /data/downloads/.in_progress/torrents
    mkdir -p /data/downloads/.torrents
    mkdir -p /data/downloads/complete/others
    chmod -R 777 /data/downloads
else
    echo "*** DISABLED creating default download directories"
fi

exec "$@"
