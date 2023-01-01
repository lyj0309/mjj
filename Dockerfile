FROM nginx
#RUN echo '这是一个本地构建的nginx镜像' > /usr/share/nginx/html/index.html

WORKDIR /root
COPY . .
RUN mv sources.list /etc/apt/sources.list && \
    rm -rf /etc/nginx/conf.d && \
    mv conf.d /etc/nginx 
    
#RUN apt update && apt install wget 

RUN mkdir /etc/xray
COPY config.json /etc/xray/config.json

RUN mkdir -p /var/log/xray /usr/share/xray \
	&& chmod +x /root/*.sh \
	&& /root/xray.sh \
ENV TZ=Asia/Shanghai
#ENTRYPOINT ["/docker-entrypoint.sh"]
ENTRYPOINT  ["/root/run.sh"]
#CMD  [ "/usr/bin/xray", "-config", "/etc/xray/config.json" ]
