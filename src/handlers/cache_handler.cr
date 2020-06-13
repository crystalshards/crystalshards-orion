require "http"
require "cache"
require "json"

class CacheHandler
  include HTTP::Handler
  getter methods : Array(String)
  getter store : Cache::MemoryStore(String, String) | Cache::FileStore(String, String) | Cache::RedisStore(String, String) | Cache::MemcachedStore(String, String) | Cache::NullStore(String, String)

  def initialize(*, @methods : Array(String) = ["GET"], @store)
  end

  def call(context)
    call_next(context) unless context.request.method === "GET"
    key = "http-cache-handler:#{context.request.path}"
    if (cached_response = store.read(key))
      io = IO::Memory.new(cached_response)
      IO.copy(io, context.response.output)
    else
      io = IO::Memory.new
      context.response.output = IO::MultiWriter.new(context.response.output, io)
      call_next(context)
      store.write(key, io.tap(&.rewind).gets_to_end)
    end
  end
end
