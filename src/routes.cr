require "sass"
require "./handlers/*"

router CrystalShards do
  use HTTP::LogHandler.new

  scope do # Assets, healthchecks, don't cache
    static path: "/assets/bootstrap.css", string: Sass.compile_file("src/scss/bootstrap/bootstrap.scss", output_style: Sass::OutputStyle::COMPRESSED)
    static path: "/assets", dir: "./src/assets"
    static path: "/healthz", string: "OK"
  end

  scope do # The primary application, to be cached
    use CacheHandler.new(store: Cache::RedisStore(String, String).new(expires_in: 30.minutes, cache: REDIS_CLIENT))

    root to: "home#home"

    scope "/shards", controller: ShardsController do
      get "/", action: index
      get "/search", action: search
      get "/:provider/*uri", action: show
    end

    scope "/tags", controller: TagsController do
      get "/", action: index
      get "/:tag", action: show
    end

    scope "/authors", controller: AuthorsController do
      get "/", action: index
      get "/:email_or_name", action: show
    end
  end
end

require "./controllers/*"
