#!/usr/bin/env bash

case "$1" in 
    start) systemctl start ark.service ;;
    stop)  systemctl stop ark.service ;;
    restart) systemctl restart ark.service ;;
    status) systemctl status ark.service ;;
    logs) journalstl -u ark.service -f ;;
    *) echo "Usage : $0 {start|stop|restart|status|logs}" ;;
esac