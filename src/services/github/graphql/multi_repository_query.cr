require "./repository"

class Service::Github::GraphQL::MultiRepositoryQuery
  class Response
    JSON.mapping(
      data: MultiRepositoryQuery
    )
  end

  JSON.mapping(
    repos: Array(Service::Github::GraphQL::Repository)
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
    variables = {
      node_ids: node_ids,
    }
    body = {
      query:     QUERY,
      variables: variables,
    }.to_json
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/graphql"
    puts "Fetching multiple repos:"
    pp variables
    puts QUERY
    response = HTTP::Client.post(url, headers, body)
    raise Exception.new("Bad response #{response.status_code}: #{response.body}") if response.status_code != 200
    puts "Response: #{response.status_code}"
    Response.from_json(response.body).data
  end
end
