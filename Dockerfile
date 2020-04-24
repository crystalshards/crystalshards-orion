FROM crystallang/crystal:0.34.0
WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install
COPY . .
RUN shards build --production

CMD ./bin/server
