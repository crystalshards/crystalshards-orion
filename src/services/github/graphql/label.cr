class Service::Github::GraphQL::Label
  JSON.mapping(
    name: {type: String}
  )

  FRAGMENT = <<-graphql
  fragment label on Label {
    name
  }

  graphql
end
