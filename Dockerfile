FROM ruby:2.1

ARG BUILD_ID=0
ENV BUILD_ID ${BUILD_ID}
ARG BUILD_COMMIT=0
ENV BUILD_COMMIT ${BUILD_COMMIT}

WORKDIR /srv
ADD . /srv
RUN mkdir -p tmp/pids tmp/cache tmp/sockets
RUN bundle install --path vendor/bundle --without development test
CMD ["bundle", "exec", "rackup", "config.ru", "--port", "3000"]
