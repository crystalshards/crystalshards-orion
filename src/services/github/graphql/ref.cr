require "./commit"

class Service::Github::GraphQL::Ref
  JSON.mapping(
    name: String,
    commit: Commit
  )

  FRAGMENT = <<-graphql
  fragment ref on Ref {
    name
    commit: target {
      ...commit
    }
  }
  #{Service::Github::GraphQL::Commit::FRAGMENT}
  graphql
end
