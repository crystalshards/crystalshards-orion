require "./tag"

class Service::Github::GraphQL::Ref
  JSON.mapping(
    tag: Tag
  )

  FRAGMENT = <<-graphql
  fragment ref on Ref {
    tag: target {
      ...tag
    }
  }
  #{Service::Github::GraphQL::Tag::FRAGMENT}
  graphql
end
