ENV["DATABASE_URL"] ||= "postgres://postgres:postgres@localhost/crystalshards"
Clear.logger.level = ::Logger::DEBUG
Clear::SQL.init(ENV["DATABASE_URL"], connection_pool_size: 5)
