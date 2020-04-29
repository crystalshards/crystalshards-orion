class Service::Github::GraphQL::Commit
  JSON.mapping(
    pushed_date: { type: Time?, key: "pushedDate" }
  )

  FRAGMENT = <<-graphql
  fragment commit on GitObject {
    ...on Commit {
      pushedDate
    }
  }
  graphql
end
