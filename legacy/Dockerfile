FROM ruby:2.6.3-alpine

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories && \
      echo "http://dl-4.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories

RUN apk upgrade --update-cache --available && \
      apk add curl unzip libexif udev xvfb dbus ttf-dejavu chromium chromium-chromedriver make gcc build-base

WORKDIR /usr/src/app/
COPY Gemfile /usr/src/app/
RUN bundle install
COPY . /usr/src/app/
