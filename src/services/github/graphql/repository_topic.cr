class Service::Github::GraphQL::RepositoryTopic
  JSON.mapping(
    topic: {type: Topic}
  )

  FRAGMENT = <<-graphql
  fragment repositoryTopic on RepositoryTopic {
    topic {
      ...topic
    }
  }
  #{Service::Github::GraphQL::Topic::FRAGMENT}
  graphql
end
