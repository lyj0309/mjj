#!/bin/bash
 
# start 1
#nginx -g daemon off;  > /var/log/start1.log 2>&1 &
/docker-entrypoint.sh nginx -g "daemon off;"  &
# start 2
#start2 > /var/log/start2.log 2>&1 &
/usr/bin/xray  -config /etc/xray/config.json
 
# just keep this script running
#while [[ true ]]; do
#    sleep 1
#done

