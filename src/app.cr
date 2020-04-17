{{ run "./require_deps.cr", "#{__DIR__}/../shard.yml" }}
GITHUB_TOKEN = ENV["GITHUB_TOKEN"]?
require "kilt/slang"
require "json"
require "yaml"
require "semantic_version"
require "./manifests/**"
require "./concerns/**"
require "./services/**"
require "./models/**"
require "./jobs/**"
require "./db/setup"
require "./db/converters"
