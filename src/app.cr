{{ run "./require_deps.cr", "#{__DIR__}/../shard.yml" }}

# Set default env vars
ENV["PORT"] ||= "3000"
ENV["CRYSTAL_LOG_LEVEL"] ||= {% if flag?(:release) %}"INFO"{% else %}"DEBUG"{% end %}
GITHUB_TOKEN = ENV["GITHUB_TOKEN"]?

require "kilt/slang"
require "json"
require "yaml"
require "colorize"
require "./log"
require "./manifests/**"
require "./concerns/**"
require "./services/**"
require "./models/**"
require "./jobs/**"
require "./db/setup"
require "./db/converters"
