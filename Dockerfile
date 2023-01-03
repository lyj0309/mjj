FROM nginx:alpine
#RUN curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 &&  chmod +x /usr/bin/dumb-init
WORKDIR /root

#RUN rm -rf /etc/nginx/conf.d 
ADD conf.d /etc/nginx/conf.d
#COPY  sources.list /etc/apt/sources.list     
#RUN apt update && apt install wget procps -y
RUN apk add --no-cache dumb-init bash
#RUN mkdir /etc/xray
ADD config.json /etc/xray/config.json

COPY xray.sh .
RUN mkdir -p /var/log/xray /usr/share/xray \
	&& /root/xray.sh \
	&& rm /root/xray.sh

ENV TZ=Asia/Shanghai

ADD web /web

ADD run.sh /run.sh
EXPOSE 80
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/run.sh"]
#ENTRYPOINT  ["/root/run.sh"]
#CMD  [ "/usr/bin/xray", "-config", "/etc/xray/config.json" ]
