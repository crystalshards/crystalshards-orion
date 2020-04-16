require "./commit"

class Service::Github::GraphQL::Ref
  JSON.mapping(
    name: {type: String},
    commit: {type: Service::Github::GraphQL::Commit}
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
