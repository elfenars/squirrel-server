FROM ruby:2.1
WORKDIR /srv
ADD . /srv
RUN mkdir -p tmp/pids tmp/cache tmp/sockets
RUN bundle install --path vendor/bundle --without development test
CMD ["bundle", "exec", "rackup", "config.ru", "--port", "3000"]
