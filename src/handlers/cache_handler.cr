require "http"
require "cache"
require "json"

class CacheHandler
  include HTTP::Handler
  getter cache : Cache::RedisStore(String, String)

  def initialize
    redis = Redis::PooledClient.new(url: ENV["REDIS_URL"]?)
    @cache = Cache::RedisStore(String, String).new(expires_in: 30.minutes, cache: redis)
  end

  def call(context)
    call_next(context) unless context.request.method === "GET"
    key = "http-cache-handler:#{context.request.path}";
    if (cached_response = cache.read(key))
      io = IO::Memory.new(cached_response)
      IO.copy(io, context.response.output)
    else
      io = IO::Memory.new
      context.response.output = IO::MultiWriter.new(context.response.output, io)
      call_next(context)
      cache.write(key, io.tap(&.rewind).gets_to_end)
    end
  end
end
