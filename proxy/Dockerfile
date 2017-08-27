FROM ubuntu:xenial

RUN apt-get update && apt-get install -qy software-properties-common
RUN add-apt-repository ppa:certbot/certbot && \
            apt-get update && \
            apt-get install -qy python-certbot-nginx nginx ruby dnsmasq supervisor

ADD nginx.conf /etc/nginx/
RUN touch /etc/nginx/vars.conf /etc/nginx/monkeys.conf
ADD conf.d/*.conf /etc/nginx/conf.d/

COPY run-nginx /usr/bin/
COPY generate-nginx-locations /usr/bin/
COPY manage-certificates /usr/bin/
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

EXPOSE 80
EXPOSE 443
STOPSIGNAL SIGTERM

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
