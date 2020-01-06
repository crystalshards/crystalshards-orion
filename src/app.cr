{{ run "./require_deps.cr" }}
require "kilt/slang"
require "../db/setup"
require "./services/**"
require "./models/**"
require "./workers/**"
