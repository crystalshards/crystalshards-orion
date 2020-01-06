FROM crystallang/crystal:0.32.1
WORKDIR /app

ADD https://raw.githubusercontent.com/samueleaton/sentry/master/install.cr /install-sentry.cr
RUN crystal run /install-sentry.cr
RUN ls
COPY shard.* ./
RUN shards install
COPY . .
RUN shards build --production
