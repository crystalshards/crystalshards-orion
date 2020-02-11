class Github::GraphQL::Release
  JSON.mapping(
    tag_name: {type: String, key: "tagName"},
    published_at: {type: Time, key: "publishedAt"}
  )
  FRAGMENT = <<-graphql
  fragment release on Release {
    tagName
    publishedAt
  }
  graphql
end
