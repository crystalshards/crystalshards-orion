class Service::Github::GraphQL::Commit
  JSON.mapping(
    authored_date: {type: Time?, key: "authoredDate"},
    pushed_date: {type: Time?, key: "pushedDate"}
  )

  FRAGMENT = <<-graphql
  fragment commit on GitObject {
    ...on Commit {
      authoredDate
      pushedDate
    }
  }
  graphql
end
