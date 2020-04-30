require "./commit"
require "./tag"

class Service::Github::GraphQL::Ref
  JSON.mapping(
    name: String,
    tag: Tag,
    commit: Commit
  )

  FRAGMENT = <<-graphql
  fragment ref on Ref {
    name
    tag: target {
      ...tag
    }
    commit: target {
      ...commit
    }
  }
  #{Service::Github::GraphQL::Tag::FRAGMENT}
  #{Service::Github::GraphQL::Commit::FRAGMENT}
  graphql
end
