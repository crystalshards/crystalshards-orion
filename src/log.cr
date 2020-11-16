require "log"

module Service
  Log = ::Log.for("services")
end

module Job
  Log = ::Log.for("jobs")
end

Log.setup_from_env(
  builder: Log.builder,
  default_level: :error,
  log_level_env: "LOG_LEVEL",
  default_sources: ENV.fetch("LOG_SOURCES", "*"),
  backend: Log::IOBackend.new
)
