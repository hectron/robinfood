FROM ruby:2.6.3

# Use the official PostgreSQL repositories for Debian Stretch
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt update && apt install -y postgresql-client-11 nodejs yarn chromium chromium-driver

WORKDIR /usr/src/app
RUN gem update --system && gem install bundler -v 2.0.1

ENV PORT 3000
EXPOSE $PORT

ENTRYPOINT ["bin/entrypoint.sh"]

COPY Gemfile* /usr/src/app/
RUN bundle install
COPY . /usr/src/app
