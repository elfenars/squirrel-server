FROM ruby:2.1-alpine
ENV RACK_ENV=production

WORKDIR /srv
ADD . /srv
RUN mkdir -p tmp/pids tmp/cache tmp/sockets
RUN bundle install --path vendor/bundle --without development test
CMD ["bundle", "exec", "rackup", "config.ru", "--port", "3000"]
