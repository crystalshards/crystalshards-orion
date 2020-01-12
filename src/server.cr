require "./app"
require "./routes"

ENV["PORT"] ||= "3000"

puts "listening on port #{ENV["PORT"]}"
Server.listen(host: "0.0.0.0", port: ENV["PORT"].to_i)
