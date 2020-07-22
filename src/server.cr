require "orion/app"
require "./views/helpers/**"
require "./controllers/*"
require "./app"

config.port = ENV["PORT"]? || 3000
config.host = "0.0.0.0"

use HTTP::LogHandler.new

static path: "/assets/bootstrap.css", string: Sass.compile_file("src/scss/bootstrap/bootstrap.scss", output_style: Sass::OutputStyle::COMPRESSED)
static path: "/assets", dir: "./assets"
static path: "/healthz", string: "OK"

scope do # The primary application, to be cached
  {% if flag?(:release) %}
    use HTTPCacheHandler.new(expires_in: 3.hours, redis: REDIS_CLIENT)
  {% end %}

  root controller: HomeController, action: home

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
