ENV["POSTGRES_URL"] ||= "postgres://postgres@localhost/crystalshards"
Clear::SQL.init(ENV["POSTGRES_URL"], connection_pool_size: 5)
