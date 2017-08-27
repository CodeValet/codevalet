FROM alpine

RUN apk add -U ruby dnsmasq supervisor \
                certbot \
                nginx nginx-mod-http-headers-more nginx-mod-http-geoip

ADD nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf && touch /etc/nginx/vars.conf /etc/nginx/monkeys.conf
ADD conf.d/*.conf /etc/nginx/conf.d/


COPY run-nginx /usr/bin/
COPY generate-nginx-locations /usr/bin/
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

EXPOSE 80
EXPOSE 443
STOPSIGNAL SIGTERM

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
