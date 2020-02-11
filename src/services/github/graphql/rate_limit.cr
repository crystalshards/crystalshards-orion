class Github::GraphQL::RateLimit
  JSON.mapping(
    cost: Int32?,
    node_count: {type: Int32?, key: "nodeCount"},
    remaining: Int32?,
    reset_at: {type: String?, key: "resetAt"}
  )
end
