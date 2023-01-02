FROM nginx
RUN curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 &&  chmod +x /usr/bin/dumb-init
WORKDIR /root

RUN rm -rf /etc/nginx/conf.d 
COPY conf.d /etc/nginx
    
#RUN apt update && apt install wget 

RUN mkdir /etc/xray
COPY config.json /etc/xray/config.json

COPY xray.sh .
RUN mkdir -p /var/log/xray /usr/share/xray \
	&& chmod +x /root/*.sh \
	&& /root/xray.sh \
ENV TZ=Asia/Shanghai


COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/run.sh"]
#ENTRYPOINT  ["/root/run.sh"]
#CMD  [ "/usr/bin/xray", "-config", "/etc/xray/config.json" ]
