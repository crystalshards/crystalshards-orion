require "./repository"

class Service::Github::GraphQL::MultiRepositoryQuery
  JSON.mapping(
    repos: Array(Service::Github::GraphQL::Repository?)
  )

  QUERY = <<-graphql
  query ($node_ids: [ID!]!) {
    repos: nodes(ids: $node_ids) {
      ...repo_fragment
    }
  }
  #{Service::Github::GraphQL::Repository::FRAGMENT}
  graphql

  def self.fetch(*, node_ids : Array(String))
    Response(self).fetch(node_ids: node_ids)
  end
end
