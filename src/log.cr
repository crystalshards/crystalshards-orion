require "log"

module Service
  Log = ::Log.for("services")
end

module Job
  Log = ::Log.for("jobs")
end

Log.setup_from_env(
  builder: Log.builder,
  level: ENV["CRYSTAL_LOG_LEVEL"],
  sources: ENV.fetch("CRYSTAL_LOG_SOURCES", "*"),
  backend: Log::IOBackend.new
)
