#!/bin/bash
 
if ! test -z "$PORT";then
	sed -i "s/80/$PORT/"  /etc/nginx/conf.d/default.conf
fi

if ! test -z "$ID";then
	sed -i "s/c2f55f35-4625-4703-a38e-b218bdf0e72a/$ID/" /etc/xray/config.json
fi

if ! test -z "$WS_PATH";then
	sed -i "s/c077651db84bcea/$WS_PATH/" /etc/xray/config.json
	sed -i "s/c077651db84bcea/$WS_PATH/" /etc/nginx/conf.d/default.conf
fi


#if test -z "$CONFIG_URL";then

#fi


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

