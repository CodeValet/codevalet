FROM ruby:2.3-alpine

ARG APP_DIR=/webapp

RUN mkdir -p ${APP_DIR}/vendor

WORKDIR ${APP_DIR}

ADD vendor/ ${APP_DIR}/vendor/

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
CMD bundle exec rackup -o 0.0.0.0
