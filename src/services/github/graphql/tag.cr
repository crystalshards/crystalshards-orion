require "./commit"

class Service::Github::GraphQL::Tag
  JSON.mapping(
    name: String?,
    commit: Commit?
  )

  FRAGMENT = <<-graphql
  fragment tag on GitObject {
    ...on Tag {
      name
      commit: target {
        ...commit
      }
    }
  }
  graphql
end
