ENV["DATABASE_URL"] ||= "postgres://postgres:postgres@localhost/crystalshards"
Clear.logger.level = Logger::Severity.parse(ENV["CRYSTAL_LOG_LEVEL"])
Clear::SQL.init(ENV["DATABASE_URL"], connection_pool_size: 5)
