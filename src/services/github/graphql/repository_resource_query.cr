require "./repository"

class Service::Github::GraphQL::RepositoryResourceQuery
  class Response
    JSON.mapping(
      data: Service::Github::GraphQL::RepositoryResourceQuery
    )
  end

  JSON.mapping(
    repo: Service::Github::GraphQL::Repository
  )

  QUERY = <<-graphql
  query (url: URI!) {
    repo: resource(url: $url) {
      ...repo_fragment
    }
  }
  #{Service::Github::GraphQL::Repository::FRAGMENT}
  graphql

  def self.fetch(*, url : String)
    variables = {
      url: url,
    }
    body = {
      query:     QUERY,
      variables: variables,
    }.to_json
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/graphql"
    puts "Fetching repo by resource url:"
    pp variables
    puts QUERY
    response = HTTP::Client.post(url, headers, body)
    raise Exception.new("Bad response #{response.status_code}: #{response.body}") if response.status_code != 200
    puts "Response: #{response.status_code}"
    Response.from_json(response.body).data
  end
end
