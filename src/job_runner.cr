require "http/server"
require "./app"

spawn do # Hack for gitlab liveness/readiness check
  server = HTTP::Server.new do |context|
    context.response.respond_with_status(200)
  end
  server.listen("0.0.0.0", ENV["PORT"].to_i)
end

Mosquito::Runner.start
