require "clear"
require "../src/db/setup"
require "../src/db/migrations/*"

Clear::CLI.run
