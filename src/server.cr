require "./app"
require "./routes"

ENV["PORT"] ||= "3000"

CrystalShards.start(host: "0.0.0.0", port: ENV["PORT"].to_i, workers: System.cpu_count)
