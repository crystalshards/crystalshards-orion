require "./app"
require "./routes"

CrystalShards.start(
  host: "0.0.0.0",
  port: ENV["PORT"].to_i,
  workers: System.cpu_count
)
