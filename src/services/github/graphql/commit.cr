class Github::GraphQL::Commit
  JSON.mapping(
    pushed_date: {type: Time, key: "pushedDate"}
  )

  FRAGMENT = <<-graphql
  fragment ref on Ref {
    pushedDate
  }
  graphql
end
