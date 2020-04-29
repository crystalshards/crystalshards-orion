require "./commit"

class Service::Github::GraphQL::Tag
  JSON.mapping(
    name: String?,
    commit: {type: Commit, key: "commit"}
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
  #{Service::Github::GraphQL::Commit::FRAGMENT}
  graphql
end
