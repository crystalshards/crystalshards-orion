require "./commit"

class Github::GraphQL::Ref
  JSON.mapping(
    name: {type: String},
    commit: {type: Commit}
  )

  FRAGMENT = <<-graphql
  fragment ref on Ref {
    name
    commit: target {
      ...commit
    }
  }

  #{Github::GraphQL::Commit::FRAGMENT}
  graphql
end
