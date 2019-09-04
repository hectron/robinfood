FROM ruby:2.6.3

# Use the official PostgreSQL repositories for Debian Stretch
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt update
RUN apt install -y postgresql-client-11 nodejs
WORKDIR /usr/src/app
RUN gem update --system && gem install bundler -v 2.0.1

ENV PORT 3000
EXPOSE $PORT

ENTRYPOINT ["bin/entrypoint.sh"]

COPY Gemfile* /usr/src/app/
RUN bundle install
COPY . /usr/src/app
