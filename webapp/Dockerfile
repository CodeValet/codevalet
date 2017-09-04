FROM ruby:2.3-alpine

ARG BUILD_PKGS="ruby-dev openssl-dev gcc make libc-dev binutils"
ARG APP_DIR=/webapp

RUN mkdir -p ${APP_DIR}/vendor

WORKDIR ${APP_DIR}

ENV GEM_HOME=${APP_DIR}/vendor/gems
ENV BUNDLE_PATH=${APP_DIR}/vendor/gems
ENV BUNDLE_APP_CONFIG=${APP_DIR}/vendor/gems/.bundle
ENV BUNDLE_DISABLE_SHARED_GEMS=true

ADD Gemfile* ${APP_DIR}/
ADD app.rb ${APP_DIR}/
ADD monkeys.txt ${APP_DIR}/
ADD config.ru ${APP_DIR}/
ADD views ${APP_DIR}/views/
ADD assets ${APP_DIR}/assets/

RUN apk add -U ${BUILD_PKGS} && \
        bundle install && \
        apk del ${BUILD_PKGS} && \
        rm -rf /var/cache/apk/*

CMD bundle exec puma
