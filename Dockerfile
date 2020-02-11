FROM crystallang/crystal:0.32.1
WORKDIR /app
COPY shard.* ./
RUN shards install
COPY . .
RUN shards build --production
