FROM alpine

RUN apk add -U bash dnsmasq supervisor nginx nginx-mod-http-headers-more nginx-mod-http-geoip

ADD nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf && touch /etc/nginx/vars.conf
ADD conf.d/*.conf /etc/nginx/conf.d/


COPY run-nginx /
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

EXPOSE 80
EXPOSE 443
STOPSIGNAL SIGTERM

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
