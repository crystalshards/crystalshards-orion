ENV["DATABASE_URL"] ||= "postgres://postgres@localhost/crystalshards"
Clear::SQL.init(ENV["DATABASE_URL"], connection_pool_size: 5)
