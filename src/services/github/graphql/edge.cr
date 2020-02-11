class Github::GraphQL::Edge(T)
  JSON.mapping(
    cursor: String?,
    node: T?
  )
end
