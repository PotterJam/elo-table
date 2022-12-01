# Rails production setup via SQLite3 made durable by https://litestream.io/
# Copy this to Dockerfile on a fresh rails app. Deploy to fly.io or any other container engine.
#
#  try locally: docker build . -t rails && docker run -p3000:3000 -it rails
#
#  in production you might want to map /data to somewhere on the host,
#  but you don't have to!
#
FROM ruby:3.1.3

ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
#ARM: ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-arm64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

ENV RAILS_ENV 'production'
ENV DB_PATH 'db/production.sqlite3'

# find a REPLICA_URL host/keys setup for persisting your sqlite3 database ( https://litestream.io/guides/ )
# supports sftp, s3, azure, google cloud storage, backblaze, etc. you probably have an account
# already
ENV REPLICA_URL 'redacted'
ENV LITESTREAM_ACCESS_KEY_ID 'redacted'
ENV LITESTREAM_SECRET_ACCESS_KEY 'redacted'

# get dependencies
WORKDIR /app
ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install

# add code (and bundle)
ADD . /app
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD \
  # if the db file doesn't exist we get it from the REPLICA_URL
  [ ! -f $DB_PATH ] && litestream restore -if-replica-exists -o $DB_PATH "${REPLICA_URL}" \
  # then we run the migrations
  ; bundle exec rake db:migrate \
  # then we launch replicate and execute rails server
  ; litestream replicate -exec "bundle exec rails server -p 3000" $DB_PATH $REPLICA_URL