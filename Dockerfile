FROM crystallang/crystal:0.35.1

RUN apt-get update -y && apt-get install -y libsass-dev build-essential cmake python

COPY shard.yml shard.lock ./
RUN shards install
COPY . .

RUN shards build server --production --release
RUN shards build job_runner --production


ENV PORT 5000

CMD ./bin/server
