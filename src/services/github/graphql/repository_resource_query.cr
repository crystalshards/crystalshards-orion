require "./repository"

class Service::Github::GraphQL::RepositoryResourceQuery
  JSON.mapping(
    repo: Service::Github::GraphQL::Repository?
  )

  QUERY = <<-graphql
  query ($url: URI!) {
    repo: resource(url: $url) {
      ...repo_fragment
    }
  }
  #{Service::Github::GraphQL::Repository::FRAGMENT}
  graphql

  def self.fetch(*, url : String)
    Response(self).fetch(url: url)
  end
end
