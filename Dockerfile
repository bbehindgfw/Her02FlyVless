FROM nginx:1.19.3-alpine
ENV TZ=Asia/Shanghai
RUN apk add --no-cache --virtual .build-deps ca-certificates bash curl unzip php7
COPY nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/static-html /usr/share/nginx/html/index
COPY nginx/h5-speedtest /usr/share/nginx/html/speedtest
COPY configure.sh /configure.sh
COPY v2ray_config /
RUN chmod +x /configure.sh
RUN sysctl net.ipv4.tcp_available_congestion_control
RUN echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
RUN sysctl -p
RUN sysctl net.ipv4.tcp_available_congestion_control
ENTRYPOINT ["sh", "/configure.sh"]
