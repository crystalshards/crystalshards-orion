{{ run "./require_deps.cr", "#{__DIR__}/../shard.yml" }}
ENV["PORT"] ||= "3000"
GITHUB_TOKEN = ENV["GITHUB_TOKEN"]?
require "kilt/slang"
require "json"
require "yaml"
require "colorize"
require "./manifests/**"
require "./concerns/**"
require "./services/**"
require "./models/**"
require "./jobs/**"
require "./db/setup"
require "./db/converters"
