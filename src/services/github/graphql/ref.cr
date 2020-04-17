class Service::Github::GraphQL::Ref
  JSON.mapping(
    name: {type: String}
  )

  FRAGMENT = <<-graphql
  fragment ref on Ref {
    name
  }

  graphql
end
