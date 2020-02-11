class Github::GraphQL::Connection(T)
  JSON.mapping(
    total_count: {type: Int32?, key: "totalCount"},
    nodes: Array(T)?,
    edges: Array(Github::GraphQL::Edge(T))?
  )
end
