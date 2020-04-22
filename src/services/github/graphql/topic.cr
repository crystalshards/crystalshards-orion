class Service::Github::GraphQL::Topic
  JSON.mapping(
    name: {type: String}
  )

  FRAGMENT = <<-graphql
  fragment topic on Topic {
    name
  }
  graphql
end
