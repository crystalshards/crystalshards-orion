ENV["DATABASE_URL"] ||= "postgres://postgres:postgres@localhost/crystalshards"
{% unless flag?(:release) %}Clear.logger.level = ::Logger::DEBUG{% end %}
Clear::SQL.init(ENV["DATABASE_URL"], connection_pool_size: 5)
